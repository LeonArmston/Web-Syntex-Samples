#!/usr/bin/env pwsh

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

New-Item -Path ./main/docs -Name "demos" -ItemType "directory"
copy-item -Force ./main/models/* -Destination ./main/docs/demos
Get-item ./main/models/* | Foreach-Object {
  if($_.PSIsContainer){
      $_.BaseName
      Copy-Item "./main/models/$($_.Name)/*.md" -Destination "./main/docs/demos/$($_.Name)" -Force
      Copy-Item "./main/models/$($_.Name)/*.png" -Destination "./main/docs/demos/$($_.Name)" -Force

      if(Test-Path "./main/models/$($_.Name)/docs-images"){
        New-Item -Path "./main/docs/demos/$($_.Name)/" -Name "docs-images" -ItemType "directory" -Force
        Copy-Item "./main/models/$($_.Name)/docs-images/*.png" -Destination "./dev/docs/demos/$($_.Name)/docs-images" -Force
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
