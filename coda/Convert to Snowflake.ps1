Add-Type -AssemblyName PresentationFramework #para janelas de erro ou sucesso



function achaLinhaTbVenda ($idVenda) {
    foreach ($linha in Get-Content .\tbVenda.txt){
        if($idVenda -eq ($linha -split " \| ")[0]){
            return $linha
        }
    }
}

function achaLinhaTbProduto ($idProd) {
    foreach ($linha in Get-Content .\tbProduto.txt){
        if($idProd -eq ($linha -split " \| ")[0]){
            return $linha
        }
    }
}

function achaLinhaMes ($idMes) {
    foreach ($linha in Get-Content ".\SnowFlake Schema\tbMês.txt"){
        if($idMes -eq ($linha -split "\|")[0]){
            return (($linha -split "\|")[1])
        }
    }
}

function achaLinhaAno ($idAno) {
    foreach ($linha in Get-Content ".\SnowFlake Schema\tbAno.txt"){
        if($idAno -eq ($linha -split "\|")[0]){
            return (($linha -split "\|")[1])
        }
    }
}

function achaLinhaFato ($idLoja, $idProd, $Ano, $Mes){
    [int]$achado=0
    [int]$cont=0
    foreach ($linha in Get-Content ".\SnowFlake Schema\tbFato.txt"){

        if($idLoja -eq ($linha -split "\|")[0] -and $idProd -eq ($linha -split "\|")[1] -and $Ano -eq ($linha -split "\|")[2] -and $Mes -eq ($linha -split "\|")[3]){
            $achado++
            break
        }
        $cont++
    }
    
    if($achado -eq 0){ #caso não tenha achado nenhuma linha correspondente, retorna -1
        return -1
    }
    else{ #caso tenha achado a linha correspondente, retorna o índice dela
        return $cont
    }

}

#
#
### Início do aplicativo ################################################
#
#

foreach ($linhaItem in Get-Content .\tbItemVenda.txt){
    $idVenda= ($linhaItem -split " \| ")[0]
    $idProd = ($linhaItem -split " \| ")[1]
    [int]$qtdProd= ($linhaItem -split " \| ")[2]

    $preçoProd= ((achaLinhaTbProduto $idProd) -split " \| ")[2]
    $custoProd= ((achaLinhaTbProduto $idProd) -split " \| ")[3]


    $idLoja =    ((achaLinhaTbVenda $idVenda) -split " \| ")[1]
    $horaVenda = ((achaLinhaTbVenda $idVenda) -split " \| ")[2]

    $idMes = $horaVenda[2] + $horaVenda[3] #captura o id do mês
    $idAno = $horaVenda[4] + $horaVenda[5]
    $mes= achaLinhaMes $idMes #com o id, captura o nome do mês
    $ano= achaLinhaAno $idAno




    #Geração de tabela fato falsa
    #Write-Host "$idLoja|$idProd|$ano|$mes|$qtdProd|$preçoProd|$valorVenda|$custoProd"
    [float]$valorVenda= ([float]($preçoProd -replace ',','.')) * $qtdProd #converte vírgulas em pontos, converte pra float e multiplica
    [string]$valorVenda=$valorVenda -replace '\.',',' #converte de volta pra string com vírgulas no lugar de pontos
    Add-Content -Value "$idLoja|$idProd|$ano|$mes|$qtdProd|$preçoProd|$valorVenda|$custoProd" -Path ".\SnowFlake Schema\tbFatoFalsa.txt"




    $indice= achaLinhaFato $idLoja $idProd $ano $mes
    $dado=""
    
    if($indice -eq -1){ #Se ainda não houver uma linha com esses IDs

        [float]$valorVenda= ([float]($preçoProd -replace ',','.')) * $qtdProd #converte vírgulas em pontos, converte pra float e multiplica
        [string]$valorVenda=$valorVenda -replace '\.',',' #converte de volta pra string com vírgulas no lugar de pontos

        Add-Content -Value "$idLoja|$idProd|$ano|$mes|$qtdProd|$preçoProd|$valorVenda|$custoProd" -Path ".\SnowFlake Schema\tbFato.txt" #A adiciona na tebela fato

    }
    else{#Se já houver alguma linha com esses IDs
        $dado= Get-Content ".\SnowFlake Schema\tbFato.txt"
        $reconst=$dado[$indice]
        $qtdProd= $qtdProd + [int](($reconst -split "\|")[4]) #qtdProd anterior é somado com o novo

        [float]$valorVenda= ([float]($preçoProd -replace ',','.')) * $qtdProd #converte vírgulas em pontos, converte pra float e multiplica
        [string]$valorVenda=$valorVenda -replace '\.',',' #converte de volta pra string com vírgulas no lugar de pontos

        $novo="$idLoja|$idProd|$ano|$mes|$qtdProd|$preçoProd|$valorVenda|$custoProd"

        
            $dado[$indice]=$novo
        
        

        Clear-Content -Path ".\SnowFlake Schema\tbFato.txt"
        Add-Content -Value $dado -Path ".\SnowFlake Schema\tbFato.txt"

    }
    
    
    
    

}


        




