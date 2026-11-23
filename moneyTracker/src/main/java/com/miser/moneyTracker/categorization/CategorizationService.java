package com.miser.moneyTracker.categorization;

import com.miser.moneyTracker.category.Category;
import com.miser.moneyTracker.category.CategoryRepository;
import com.miser.moneyTracker.category.SubCategory;
import com.miser.moneyTracker.category.SubCategoryRepository;
import com.miser.moneyTracker.merchant.Merchant;
import com.miser.moneyTracker.merchant.MerchantRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;

/**
 * Rule-based auto-categorization of statement narrations: extracts a merchant
 * from UPI/POS/NEFT-style descriptions and maps well-known keywords onto the
 * seeded categories. Unknown descriptions fall back to "Other" so every
 * transaction lands somewhere the user can re-categorize later.
 */
@Service
@RequiredArgsConstructor
public class CategorizationService {

    private final CategoryRepository categoryRepository;
    private final SubCategoryRepository subCategoryRepository;
    private final MerchantRepository merchantRepository;

    private record Rule(String keyword, String category, String subCategory) {}

    // First match wins; more specific keywords go first.
    private static final List<Rule> RULES = List.of(
            new Rule("swiggy instamart", "Food", "Grocery"),
            new Rule("swiggy", "Food", "Delivery"),
            new Rule("zomato", "Food", "Delivery"),
            new Rule("eatclub", "Food", "Delivery"),
            new Rule("blinkit", "Food", "Grocery"),
            new Rule("zepto", "Food", "Grocery"),
            new Rule("bigbasket", "Food", "Grocery"),
            new Rule("dmart", "Food", "Grocery"),
            new Rule("grocery", "Food", "Grocery"),
            new Rule("starbucks", "Food", "Cafe"),
            new Rule("barista", "Food", "Cafe"),
            new Rule("cafe", "Food", "Cafe"),
            new Rule("mcdonald", "Food", "Restaurant"),
            new Rule("kfc", "Food", "Restaurant"),
            new Rule("dominos", "Food", "Restaurant"),
            new Rule("pizza", "Food", "Restaurant"),
            new Rule("restaurant", "Food", "Restaurant"),

            new Rule("amazon", "Shopping", "Online"),
            new Rule("flipkart", "Shopping", "Online"),
            new Rule("myntra", "Shopping", "Clothing"),
            new Rule("ajio", "Shopping", "Clothing"),
            new Rule("meesho", "Shopping", "Online"),
            new Rule("nykaa", "Shopping", "Online"),
            new Rule("croma", "Shopping", "Electronics"),
            new Rule("reliance digital", "Shopping", "Electronics"),

            new Rule("uber", "Travel", "Cab"),
            new Rule("olacabs", "Travel", "Cab"),
            new Rule("ola", "Travel", "Cab"),
            new Rule("rapido", "Travel", "Cab"),
            new Rule("petrol", "Travel", "Fuel"),
            new Rule("fuel", "Travel", "Fuel"),
            new Rule("hpcl", "Travel", "Fuel"),
            new Rule("bpcl", "Travel", "Fuel"),
            new Rule("indian oil", "Travel", "Fuel"),
            new Rule("iocl", "Travel", "Fuel"),
            new Rule("indigo", "Travel", "Flight"),
            new Rule("air india", "Travel", "Flight"),
            new Rule("vistara", "Travel", "Flight"),
            new Rule("spicejet", "Travel", "Flight"),
            new Rule("makemytrip", "Travel", "Flight"),
            new Rule("goibibo", "Travel", "Flight"),
            new Rule("cleartrip", "Travel", "Flight"),
            new Rule("oyo", "Travel", "Hotel"),
            new Rule("hotel", "Travel", "Hotel"),
            new Rule("irctc", "Travel", null),
            new Rule("redbus", "Travel", null),
            new Rule("metro", "Travel", null),

            new Rule("electricity", "Bills", "Electricity"),
            new Rule("bescom", "Bills", "Electricity"),
            new Rule("msedcl", "Bills", "Electricity"),
            new Rule("bses", "Bills", "Electricity"),
            new Rule("broadband", "Bills", "Internet"),
            new Rule("jiofiber", "Bills", "Internet"),
            new Rule("wifi", "Bills", "Internet"),
            new Rule("airtel", "Bills", "Phone"),
            new Rule("jio", "Bills", "Phone"),
            new Rule("vodafone", "Bills", "Phone"),
            new Rule("bsnl", "Bills", "Phone"),
            new Rule("recharge", "Bills", "Phone"),
            new Rule("rent", "Bills", "Rent"),

            new Rule("netflix", "Entertainment", null),
            new Rule("spotify", "Entertainment", null),
            new Rule("hotstar", "Entertainment", null),
            new Rule("prime video", "Entertainment", null),
            new Rule("bookmyshow", "Entertainment", null),
            new Rule("pvr", "Entertainment", null),
            new Rule("inox", "Entertainment", null),

            new Rule("pharmacy", "Medical", null),
            new Rule("pharmeasy", "Medical", null),
            new Rule("1mg", "Medical", null),
            new Rule("netmeds", "Medical", null),
            new Rule("medplus", "Medical", null),
            new Rule("apollo", "Medical", null),
            new Rule("hospital", "Medical", null),
            new Rule("clinic", "Medical", null),

            new Rule("zerodha", "Investment", null),
            new Rule("groww", "Investment", null),
            new Rule("upstox", "Investment", null),
            new Rule("mutual fund", "Investment", null),
            new Rule("sip", "Investment", null),
            new Rule("etmoney", "Investment", null),
            new Rule("indmoney", "Investment", null),

            new Rule("udemy", "Education", null),
            new Rule("coursera", "Education", null),
            new Rule("unacademy", "Education", null),
            new Rule("byjus", "Education", null),
            new Rule("school fee", "Education", null),
            new Rule("tuition", "Education", null),

            new Rule("salary", "Salary", null),

            new Rule("self transfer", "Transfer", null),
            new Rule("own account", "Transfer", null)
    );

    // Payment-rail noise that should never be treated as the merchant name.
    private static final Set<String> NOISE_TOKENS = Set.of(
            "upi", "pos", "neft", "imps", "rtgs", "ach", "atm", "atw", "nach", "ecs",
            "vps", "visa", "mastercard", "rupay", "intl", "dc", "cc", "payment", "pay",
            "to", "from", "transfer", "txn", "purchase", "p2a", "p2m", "mmt", "ref");

    private static final Pattern NON_ALNUM = Pattern.compile("[^a-z0-9 ]+");

    private Map<String, Category> categoriesByName;
    private Map<String, SubCategory> subCategoriesByKey;

    @Transactional
    public CategorizationResult categorize(String description) {
        loadLookupsIfNeeded();
        String lower = description == null ? "" : description.toLowerCase(Locale.ENGLISH);

        Category category = null;
        SubCategory subCategory = null;
        String matchedKeyword = null;
        for (Rule rule : RULES) {
            if (matches(lower, rule.keyword())) {
                category = categoriesByName.get(rule.category().toLowerCase(Locale.ENGLISH));
                if (rule.subCategory() != null) {
                    subCategory = subCategoriesByKey.get(
                            (rule.category() + "/" + rule.subCategory()).toLowerCase(Locale.ENGLISH));
                }
                matchedKeyword = rule.keyword();
                break;
            }
        }
        if (category == null) {
            category = categoriesByName.get("other");
        }

        String merchantName = matchedKeyword != null ? matchedKeyword : extractMerchantName(lower);
        Merchant merchant = merchantName == null ? null : getOrCreateMerchant(merchantName);
        return new CategorizationResult(merchant, category, subCategory);
    }

    /**
     * Short keywords ("ola", "sip", "jio") need word boundaries to avoid
     * matching inside unrelated words; longer ones can match as substrings
     * so "amazonpay" still hits "amazon".
     */
    private static boolean matches(String description, String keyword) {
        if (keyword.length() > 4) {
            return description.contains(keyword);
        }
        return Pattern.compile("\\b" + Pattern.quote(keyword) + "\\b")
                .matcher(description).find();
    }

    /**
     * Pulls a plausible merchant out of narrations like
     * "UPI-SWIGGY-swiggy@icici-123456" or "POS 411111 BIG BAZAAR MUMBAI".
     */
    static String extractMerchantName(String lowerDescription) {
        if (lowerDescription == null || lowerDescription.isBlank()) return null;
        for (String segment : lowerDescription.split("[/\\-|]")) {
            String cleaned = NON_ALNUM.matcher(segment.replaceAll("@\\S*", ""))
                    .replaceAll(" ").trim().replaceAll("\\s+", " ");
            if (cleaned.isEmpty()) continue;
            // Drop leading rail keywords, card/ref numbers and IFSC codes.
            var words = new ArrayList<>(List.of(cleaned.split(" ")));
            while (!words.isEmpty() && (NOISE_TOKENS.contains(words.get(0))
                    || words.get(0).matches("[0-9]+")
                    || words.get(0).matches("[a-z]{4}0[a-z0-9]{6}"))) {
                words.remove(0);
            }
            if (words.isEmpty()) continue;
            String candidate = String.join(" ", words);
            if (candidate.length() < 3) continue;
            return candidate.length() > 60 ? candidate.substring(0, 60) : candidate;
        }
        return null;
    }

    private Merchant getOrCreateMerchant(String name) {
        String normalized = name.toLowerCase(Locale.ENGLISH).trim();
        return merchantRepository.findByNormalizedName(normalized)
                .orElseGet(() -> merchantRepository.save(Merchant.builder()
                        .name(titleCase(normalized))
                        .normalizedName(normalized)
                        .build()));
    }

    private synchronized void loadLookupsIfNeeded() {
        if (categoriesByName != null) return;
        Map<String, Category> categories = new LinkedHashMap<>();
        for (Category category : categoryRepository.findAll()) {
            categories.put(category.getName().toLowerCase(Locale.ENGLISH), category);
        }
        Map<String, SubCategory> subCategories = new LinkedHashMap<>();
        for (SubCategory subCategory : subCategoryRepository.findAll()) {
            String key = (subCategory.getCategory().getName() + "/" + subCategory.getName())
                    .toLowerCase(Locale.ENGLISH);
            subCategories.put(key, subCategory);
        }
        this.subCategoriesByKey = subCategories;
        this.categoriesByName = categories;
    }

    private static String titleCase(String value) {
        StringBuilder result = new StringBuilder(value.length());
        boolean upperNext = true;
        for (char c : value.toCharArray()) {
            result.append(upperNext && Character.isLetter(c) ? Character.toUpperCase(c) : c);
            upperNext = c == ' ';
        }
        return result.toString();
    }
}
