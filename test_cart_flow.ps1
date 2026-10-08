# Test full cart and product variant flow

$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession

Write-Host "--- TEST 1: Empty Cart UI ---" -ForegroundColor Cyan
$resp1 = Invoke-WebRequest -Uri "http://localhost:8080/cart" -WebSession $session -UseBasicParsing
if ($resp1.Content -match "GIỎ HÀNG CỦA BẠN" -and $resp1.Content -match "Giỏ hàng của bạn đang trống" -and $resp1.Content -match "TIẾP TỤC MUA SẮM") {
    Write-Host "[PASS] Empty cart renders title, empty message and 'TIẾP TỤC MUA SẮM' button matching screenshot." -ForegroundColor Green
} else {
    Write-Host "[FAIL] Empty cart content mismatch." -ForegroundColor Red
}

Write-Host "`n--- TEST 2: Product Detail Page & Variants ---" -ForegroundColor Cyan
$resp2 = Invoke-WebRequest -Uri "http://localhost:8080/product?id=1" -WebSession $session -UseBasicParsing
if ($resp2.Content -match "variant_id" -and $resp2.Content -match "Chọn Kích cỡ" -and $resp2.Content -match "Chọn màu sắc" -and $resp2.Content -match "input_qty") {
    Write-Host "[PASS] Product detail renders variants, size & color options and quantity input." -ForegroundColor Green
} else {
    Write-Host "[FAIL] Product detail content mismatch." -ForegroundColor Red
}

Write-Host "`n--- TEST 3: Login as Customer ---" -ForegroundColor Cyan
$loginBody = @{
    email = "khachhang1@gmail.com"
    password = "123456"
}
$loginResp = Invoke-WebRequest -Uri "http://localhost:8080/login" -Method POST -Body $loginBody -WebSession $session -UseBasicParsing
Write-Host "Login response status: $($loginResp.StatusCode)" -ForegroundColor Green

Write-Host "`n--- TEST 4: Add Product with Variant & Quantity to Cart ---" -ForegroundColor Cyan
# Product ID 1, Variant ID 372 (Size M, Trắng, 150000), Quantity 2
$addResp = Invoke-WebRequest -Uri "http://localhost:8080/cart?action=add&id=1&variant_id=372&qty=2" -WebSession $session -UseBasicParsing
Write-Host "Add to cart response status: $($addResp.StatusCode)" -ForegroundColor Green

Write-Host "`n--- TEST 5: Verify Cart with Items ---" -ForegroundColor Cyan
$cartResp = Invoke-WebRequest -Uri "http://localhost:8080/cart" -WebSession $session -UseBasicParsing
if ($cartResp.Content -match "Size:.*M" -and $cartResp.Content -match "Màu:.*Trắng" -and $cartResp.Content -match "300[.,]000") {
    Write-Host "[PASS] Cart shows product with Size M, Màu Trắng, and Subtotal 300.000 VND." -ForegroundColor Green
} else {
    Write-Host "[FAIL] Cart items verification failed." -ForegroundColor Red
}

Write-Host "`n--- TEST 6: Update Cart Quantity to 3 ---" -ForegroundColor Cyan
$updateBody = "cart_key=1_372&qty=3"
$updateResp = Invoke-WebRequest -Uri "http://localhost:8080/cart" -Method POST -Body $updateBody -ContentType "application/x-www-form-urlencoded" -WebSession $session -UseBasicParsing
$cartResp2 = Invoke-WebRequest -Uri "http://localhost:8080/cart" -WebSession $session -UseBasicParsing
if ($cartResp2.Content -match "450[.,]000") {
    Write-Host "[PASS] Cart updated quantity to 3, subtotal is now 450.000 VND." -ForegroundColor Green
} else {
    Write-Host "[FAIL] Cart quantity update failed." -ForegroundColor Red
}

Write-Host "`n--- TEST 7: Delete Item from Cart ---" -ForegroundColor Cyan
$delResp = Invoke-WebRequest -Uri "http://localhost:8080/cart?action=delete&id=1_372" -WebSession $session -UseBasicParsing
$cartResp3 = Invoke-WebRequest -Uri "http://localhost:8080/cart" -WebSession $session -UseBasicParsing
if ($cartResp3.Content -match "Giỏ hàng của bạn đang trống") {
    Write-Host "[PASS] Deleted item, cart returns to empty state matching screenshot." -ForegroundColor Green
} else {
    Write-Host "[FAIL] Cart deletion failed." -ForegroundColor Red
}

Write-Host "`n=== ALL TESTS FINISHED ===" -ForegroundColor Cyan
