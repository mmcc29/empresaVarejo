Clear-Content -Path ".\SnowFlake Schema\tbProduto.txt"

foreach ($linha in Get-Content ".\tbProduto.txt"){
    $idProduto=($linha -split " \| ")[0]
    $idDepto=($linha -split " \| ")[1]
    $nmProd=($linha -split " \| ")[4]

    $novaLinha="$idProduto|$idDepto|$nmProd"

    Add-Content -Value $novaLinha -Path ".\SnowFlake Schema\tbProduto.txt"
}
  


Clear-Content -Path ".\SnowFlake Schema\tbDepartamento.txt"
foreach ($linha in Get-Content ".\tbDepartamento.txt"){
    $idDepartamento=($linha -split " \| ")[0]
    $nmDepartamento=($linha -split " \| ")[1]
    

    $novaLinha="$idDepartamento|$nmDepartamento"

    Add-Content -Value $novaLinha -Path ".\SnowFlake Schema\tbDepartamento.txt"
}


Clear-Content -Path ".\SnowFlake Schema\tbLoja.txt"
foreach ($linha in Get-Content ".\tbLoja.txt"){
    $idLoja=($linha -split " \| ")[0]
    $nmLoja=($linha -split " \| ")[2]
    

    $novaLinha="$idLoja|$nmLoja"

    Add-Content -Value $novaLinha -Path ".\SnowFlake Schema\tbLoja.txt"
}
