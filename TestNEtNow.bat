@echo off
setlocal enabledelayedexpansion

:: ====================================================================
:: Configuracao Inicial
:: ====================================================================
cls
title Teste de Conexao Automatizado

:SOLICITAR_DOMINIO
echo.
echo ====================================================================
echo ^|              INICIANDO TESTE DE CONEXAO              ^|
echo ====================================================================
echo.
set /p DOMINIO="Automaao para Breve Analise da Cnx entre Cliente Servidor. Por favor, digite o DOMINIO ou IP que deseja testar (ex: google.com): "

:: Validacao de entrada
if "%DOMINIO%"=="" (
    echo.
    echo ERRO: O campo de dominio/IP nao pode estar vazio!
    goto SOLICITAR_DOMINIO
)

:: ====================================================================
:: Geracao de Timestamp e Nome do Arquivo de Log
:: ====================================================================
:: Obtem data e hora no formato YYYYMMDD_HHMMSS
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set DATA_HORA=%dt:~0,8%_%dt:~8,6%
set ARQUIVO_LOG=Relatorio_Conexao_%DOMINIO%_%DATA_HORA%.txt

echo.
echo ====================================================================
echo ^| Dominio Alvo: %DOMINIO%
echo ^| Arquivo de Log: %ARQUIVO_LOG%
echo ====================================================================
echo.

:: 1. Criacao do Cabecalho do Relatorio
echo ==================================================================== > "%ARQUIVO_LOG%"
echo ^| Relatorio de Teste de Conexao - m3ss14s ^| >> "%ARQUIVO_LOG%"
echo ==================================================================== >> "%ARQUIVO_LOG%"
echo Data e Hora do Teste: %DATE% %TIME% >> "%ARQUIVO_LOG%"
echo Dominio Testado: %DOMINIO% >> "%ARQUIVO_LOG%"
echo. >> "%ARQUIVO_LOG%"

:: ====================================================================
:: 2. Teste NSLOOKUP (Resolucao de Nome)
:: ====================================================================
echo.
echo --- EXECUTANDO NSLOOKUP (Resolucao de Nome)...
echo.
echo --- NSLOOKUP - Resolucao de Nome (DNS) --- >> "%ARQUIVO_LOG%"
nslookup %DOMINIO% >> "%ARQUIVO_LOG%" 2>&1
echo NSLOOKUP Concluido. >> "%ARQUIVO_LOG%"
echo. >> "%ARQUIVO_LOG%"

:: ====================================================================
:: 3. Teste TRACERT (Rota da Rede)
:: ====================================================================
echo.
echo --- EXECUTANDO TRACERT (Rota da Rede)... Pode levar um tempo...
echo.
echo --- TRACERT - Rota de Pacotes (Maximo de 30 Saltos) --- >> "%ARQUIVO_LOG%"
:: Usando -d para nao resolver nomes de host, acelerando o processo.
tracert -d %DOMINIO% >> "%ARQUIVO_LOG%" 2>&1
echo TRACERT Concluido. >> "%ARQUIVO_LOG%"
echo. >> "%ARQUIVO_LOG%"

:: ====================================================================
:: 4. Teste PING (Latencia e Perda de Pacotes)
:: ====================================================================
echo.
echo --- EXECUTANDO PING (Latencia e Perda de Pacotes)... (4 Pacotes)
echo.
echo --- PING - Teste de Latencia e Perda de Pacotes (4 pacotes) --- >> "%ARQUIVO_LOG%"
ping -n 4 %DOMINIO% >> "%ARQUIVO_LOG%" 2>&1
echo PING Concluido. >> "%ARQUIVO_LOG%"
echo. >> "%ARQUIVO_LOG%"

:: ====================================================================
:: 5. Informacoes Adicionais
:: ====================================================================
echo --- Informacoes Adicionais do Sistema --- >> "%ARQUIVO_LOG%"
echo. >> "%ARQUIVO_LOG%"

echo --- Configuracao de IP (ipconfig /all) --- >> "%ARQUIVO_LOG%"
ipconfig /all >> "%ARQUIVO_LOG%" 2>&1
echo. >> "%ARQUIVO_LOG%"

echo --- Tabela de Rotas (route print) --- >> "%ARQUIVO_LOG%"
route print >> "%ARQUIVO_LOG%" 2>&1
echo. >> "%ARQUIVO_LOG%"

:: ====================================================================
:: 6. Sumario do Relatorio e Conclusao
:: ====================================================================
echo ==================================================================== >> "%ARQUIVO_LOG%"
echo ^|                TESTE DE CONEXAO CONCLUIDO                  ^| >> "%ARQUIVO_LOG%"
echo ==================================================================== >> "%ARQUIVO_LOG%"

echo.
echo ====================================================================
echo ^|               TESTE CONCLUIDO COM SUCESSO!                 ^|
echo ====================================================================
echo ^| O relatorio completo foi salvo em:
echo ^| %ARQUIVO_LOG%
echo ====================================================================
echo.

:: Abre o arquivo de log no Bloco de Notas para visualizacao imediata
start notepad "%ARQUIVO_LOG%"

pause
endlocal
