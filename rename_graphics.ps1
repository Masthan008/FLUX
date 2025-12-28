# PowerShell script to rename Engineering Graphics diagrams

# UNIT I: CURVES & SCALES
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\graphics\1.webp" "ellipse.webp" -ErrorAction SilentlyContinue
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\graphics\2.webp" "cycloid.webp" -ErrorAction SilentlyContinue
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\graphics\3.webp" "diagonal_scale.webp" -ErrorAction SilentlyContinue

# UNIT II: ORTHOGRAPHIC PROJECTIONS
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\graphics\4.webp" "points.webp" -ErrorAction SilentlyContinue
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\graphics\5.webp" "lines.webp" -ErrorAction SilentlyContinue

# UNIT III: PROJECTION OF SOLIDS
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\graphics\6.webp" "solids.webp" -ErrorAction SilentlyContinue

# UNIT IV: SECTIONS & DEVELOPMENT
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\graphics\7.webp" "sections.webp" -ErrorAction SilentlyContinue
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\graphics\8.webp" "development.webp" -ErrorAction SilentlyContinue

# UNIT V: CONVERSION OF VIEWS
Rename-Item "c:\Users\masth\students-os\assets\engineering_hub\graphics\9.webp" "iso_to_ortho.webp" -ErrorAction SilentlyContinue

Write-Host "All graphics diagrams renamed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Renamed files:" -ForegroundColor Cyan
Write-Host "1.webp -> ellipse.webp" -ForegroundColor White
Write-Host "2.webp -> cycloid.webp" -ForegroundColor White
Write-Host "3.webp -> diagonal_scale.webp" -ForegroundColor White
Write-Host "4.webp -> points.webp" -ForegroundColor White
Write-Host "5.webp -> lines.webp" -ForegroundColor White
Write-Host "6.webp -> solids.webp" -ForegroundColor White
Write-Host "7.webp -> sections.webp" -ForegroundColor White
Write-Host "8.webp -> development.webp" -ForegroundColor White
Write-Host "9.webp -> iso_to_ortho.webp" -ForegroundColor White
