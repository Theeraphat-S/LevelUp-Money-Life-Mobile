# PowerShell script to generate i18n localization files
$ErrorActionPreference = "Stop"

$LocalsDir = Join-Path $PSScriptRoot "lib\i18n\locals"
$I18nFile = Join-Path $PSScriptRoot "lib\i18n\i18n.dart"

Write-Host "Step 1: Generating localization files with flutter gen-l10n..." -ForegroundColor Cyan

$directories = Get-ChildItem -Path $LocalsDir -Directory

function To-PascalCase($str) {
    $parts = $str -split '_'
    $pascal = ($parts | ForEach-Object { 
        if ($_.Length -gt 0) {
            $_.Substring(0,1).ToUpper() + $_.Substring(1).ToLower()
        }
    }) -join ''
    return $pascal
}

function To-CamelCase($str) {
    $parts = $str -split '_'
    $camel = ""
    for ($i = 0; $i -lt $parts.Length; $i++) {
        $p = $parts[$i]
        if ($i -eq 0) {
            $camel += $p.ToLower()
        } else {
            if ($p.Length -gt 0) {
                $camel += $p.Substring(0,1).ToUpper() + $p.Substring(1).ToLower()
            }
        }
    }
    return $camel
}

foreach ($dir in $directories) {
    $pageName = $dir.Name
    $pascal = To-PascalCase $pageName
    $className = "${pascal}Localizations"
    $outputFile = "${pageName}_localizations.dart"
    $arbDirPath = "lib/i18n/locals/$pageName"

    Write-Host "  -> Generating $className for $pageName..." -ForegroundColor Green
    & flutter gen-l10n `
        --arb-dir $arbDirPath `
        --template-arb-file en.arb `
        --output-localization-file $outputFile `
        --output-class $className
}

Write-Host "`nStep 2: Generating i18n.dart..." -ForegroundColor Cyan

$sb = [System.Text.StringBuilder]::new()
[void]$sb.AppendLine("import 'package:flutter/material.dart';")
[void]$sb.AppendLine("import 'package:flutter_localizations/flutter_localizations.dart';")

foreach ($dir in $directories) {
    $pageName = $dir.Name
    [void]$sb.AppendLine("import 'package:mobile_app_standard/i18n/locals/${pageName}/${pageName}_localizations.dart';")
}

[void]$sb.AppendLine("")
[void]$sb.AppendLine("class I18n {")
[void]$sb.AppendLine("  static final all = [")
[void]$sb.AppendLine("    const Locale('en'),")
[void]$sb.AppendLine("    const Locale('th'),")
[void]$sb.AppendLine("  ];")
[void]$sb.AppendLine("}")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("class AppLocalizations {")
[void]$sb.AppendLine("  final BuildContext context;")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("  static List<LocalizationsDelegate<dynamic>> get localizationsDelegates => [")
[void]$sb.AppendLine("        GlobalCupertinoLocalizations.delegate,")
[void]$sb.AppendLine("        GlobalMaterialLocalizations.delegate,")
[void]$sb.AppendLine("        GlobalWidgetsLocalizations.delegate,")

foreach ($dir in $directories) {
    $pageName = $dir.Name
    $pascal = To-PascalCase $pageName
    $className = "${pascal}Localizations"
    [void]$sb.AppendLine("        ${className}.delegate,")
}

[void]$sb.AppendLine("      ];")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("  AppLocalizations(this.context);")
[void]$sb.AppendLine("")

foreach ($dir in $directories) {
    $pageName = $dir.Name
    $pascal = To-PascalCase $pageName
    $className = "${pascal}Localizations"
    $getterName = To-CamelCase $pageName

    [void]$sb.AppendLine("  // Get $className")
    [void]$sb.AppendLine("  $className get $getterName => $className.of(context)!;")
    [void]$sb.AppendLine("")
}

[void]$sb.AppendLine("}")

Set-Content -Path $I18nFile -Value $sb.ToString() -Encoding UTF8

Write-Host "Done! Successfully generated all localization files and $I18nFile" -ForegroundColor Green
