package com.miser.moneyTracker.user

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

data class MeResponse(val id: Long, val email: String, val name: String)

@RestController
@RequestMapping("/api/me")
class MeController(private val currentUserService: CurrentUserService) {

    /** Current user's profile; also provisions the user on first sign-in. */
    @GetMapping
    fun me(): MeResponse = currentUserService.getCurrentUser().let { MeResponse(it.id, it.email, it.name) }
}
