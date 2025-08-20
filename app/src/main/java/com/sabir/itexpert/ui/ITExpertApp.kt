package com.sabir.itexpert.ui

import androidx.compose.foundation.layout.padding
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier

@Composable
fun ITExpertApp() {
    Scaffold(topBar = { TopAppBar(title = { Text("IT Expert") }) }) { pad ->
        Text("Hello Sabir — build is working ✅", modifier = Modifier.padding(pad))
    }
}
