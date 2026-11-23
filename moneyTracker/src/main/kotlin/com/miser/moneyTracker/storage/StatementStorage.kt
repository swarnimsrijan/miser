package com.miser.moneyTracker.storage

/** Where uploaded statement files live. Keys are opaque to callers. */
interface StatementStorage {
    /** @return storage key to persist on the statement row */
    fun store(userId: Long, filename: String?, content: ByteArray, contentType: String?): String
    fun load(key: String): ByteArray
    fun delete(key: String)
}

internal fun storageKey(userId: Long, filename: String?): String {
    val safeName = (filename ?: "statement").replace(Regex("[^A-Za-z0-9._-]"), "_").takeLast(100)
    return "$userId/${java.util.UUID.randomUUID()}-$safeName"
}
