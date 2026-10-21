# Evidências da execução

## Provisionamento

O Cloud-Init foi executado com a fonte `DataSourceNoCloud` e terminou com
status `done`, sem erros ou erros recuperáveis.

## Usuário e serviços

O usuário `meu-usuario` foi criado com os grupos `sudo` e `docker`. O comando
`sudo -n whoami` retornou `root`. Nginx e Docker foram habilitados e estão
ativos.

Os resultados completos estão em
[`verificacao.txt`](verificacao.txt).

A captura visual da verificação está em
[`01-servicos-ativos.png`](01-servicos-ativos.png). O arquivo bruto retornado
pelos comandos está em [`servicos-ativos-output.txt`](servicos-ativos-output.txt).

## Página web

O Nginx retornou HTTP 200 pela porta encaminhada `2200`. A captura da página
personalizada está em [`02-pagina-web.png`](02-pagina-web.png).
