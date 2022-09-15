package com.example.demo.Controller

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController
import reactor.core.publisher.Mono

@RestController
class TestController {

    @GetMapping("/health")
    fun health()  = Mono.just("Tested")

}
