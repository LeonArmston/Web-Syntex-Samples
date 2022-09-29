#!/usr/bin/env pwsh

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

New-Item -Path ./dev/docs -Name "demos" -ItemType "directory"
copy-item -Force ./dev/models/* -Destination ./dev/docs/demos
Get-item ./dev/models/* | Foreach-Object {
  if($_.PSIsContainer){
      $_.BaseName
      Copy-Item "./dev/models/$($_.Name)/*.md" -Destination "./dev/docs/demos/$($_.Name)" -Force
      Copy-Item "./dev/models/$($_.Name)/*.png" -Destination "./dev/docs/demos/$($_.Name)" -Force

      if(Test-Path "./dev/models/$($_.Name)/docs-images"){
        New-Item -Path "./dev/docs/demos/$($_.Name)/" -Name "docs-images" -ItemType "directory" -Force
        Copy-Item "./dev/models/$($_.Name)/docs-images/*.png" -Destination "./dev/docs/demos/$($_.Name)/docs-images" -Force
      }
  }
}


#docfx metadata ./dev/docs/docfx.json --warningsAsErrors $args
docfx build ./main/docs/docfx.json --warningsAsErrors $args

# Copy the created site to the pnpcoredocs folder (= clone of the gh-pages branch)
Remove-Item ./gh-pages/scripts/* -Recurse -Force
Remove-Item ./gh-pages/sharepoint-syntex/* -Recurse -Force
Remove-Item ./gh-pages/contributing/* -Recurse -Force
Remove-Item ./gh-pages/images/* -Recurse -Force
copy-item -Force -Recurse ./main/docs/_site/* -Destination ./gh-pages
