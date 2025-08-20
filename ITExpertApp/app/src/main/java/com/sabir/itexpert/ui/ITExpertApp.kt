package com.sabir.itexpert.ui

import androidx.compose.material3.*
import androidx.compose.runtime.Composable

@Composable
fun ITExpertApp() {
    Scaffold { padding ->
        Text("IT Expert App Running", modifier = androidx.compose.ui.Modifier.padding(padding))
    }
}
