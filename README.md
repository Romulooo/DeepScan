# DeepScan 

DeepScan é um aplicativo que busca facilitar a indentificação de conteúdos gerados por inteligência artificial, podendo analisar textos e imagens em busca de traços que evidenciem seu uso. A ferramenta pode verificar tanto arquivos de imagens locais quanto endereços URLs externos para a presença do uso de inteligência artificial ou _deepfakes_, além de conter uma câmera no aplicativo que permite a verificação rápida com o simples toque de um botão.

## Como executar

Para rodar DeepScan em seu computador ou dispositivo móvel, você precisa do Flutter na versão correta e deve instalar todas as bibliotecas necessárias:
```
flutter pub get
```
Com a instalação concluída, acesse o arquivo _main.dart_, selecione o dispositivo desejado - este aplicativo não é compatível com execução em navegadores (Web).

## API

Nesse projeto a API _sightengine_ é utilizada para determinar automaticamente imagens de geradores de IA populares e manipulações de imagem e vídeo, como trocas de rosto.

### Resultado:
Exemplo de uma requisição da API:
```
"status": "success",
 "request": {
     "id": "req_fPDJ8fsQGgC1E2Ed8V",
     "timestamp": 1709634469.399,
     "operations": 1
 },
 "type": {
     "deepfake": 99% //Confiança da API que a imagem é um deepfake
 },
 "media": {
     "id": "med_fPDJiQzaZR2E193CXb",
     "uri": "image.jpg"
 }
```
