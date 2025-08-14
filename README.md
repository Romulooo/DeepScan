# 🤖 DeepScan 

DeepScan é um aplicativo desenvolvido com o intuito de facilitar a identificação de conteúdos gerados por inteligência artificial, podendo analisar textos e imagens em busca de traços que evidenciem seu uso. A ferramenta permite verificar tanto arquivos de imagens locais quanto endereços URLs externos, além de detectar possíveis _deepfakes_. O app também permite o uso da câmera do seu dispositivo, que permite a verificação rápida com o simples toque de um botão.

## 🗒️ Do que o DeepScan é capaz

O DeepScan consiste em duas páginas principais: uma para a verificação de imagens e a outra para a verificação de textos. Na página das imagens, é possível escolher o formato de envio (URL, arquivo ou foto capturada diretamente pelo aplicativo). Já na página de texto, há um campo dedicado para inserir o trecho que será analisado.

O aplicativo processa o material e apresenta ao usuário a probabilidade - em porcentagem - de que tenha sido gerado por IA, acompanhada de uma breve explicação sobre o resultado.

## 🖥️ Como executar

Para rodar DeepScan em seu computador ou dispositivo móvel, você precisa do Flutter na versão correta e deve instalar todas as bibliotecas necessárias depois de clonar o respositório:
```
flutter pub get
```
Com a instalação concluída, acesse o arquivo _main.dart_ e selecione o dispositivo desejado para rodar a aplicação. Este aplicativo não é compatível com execução em navegadores (Web).

## ⚙️ API

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
     "uri": "imagem.jpg"
 }
```

Já para a verificação de texto, é utilizada a API _Sapling's API_ que calcula a probabilidade de um trecho de texto ser gerado por IA sendo treinado para lidar com diferentes fornecedores (como GPT da OpenAI e modelos Gemini).

### Resultado:

```
{
    "score": 0.8016229165451867, //Confiança da API que o texto é gerado por IA
    "sentence_scores": [
        {
            "score": 1.1537837352193492e-10,
            "sentence": "Aqui está um texto."
        }
    ],
    "text": "Aqui está um texto.",
    "token_probs": [
        0.8062431365251541,
        0.8068526238203049,
        0.8062431365251541,
        0.8080672174692154,
        0.8062431365251541
    ],
    "tokens": [
        "Aqui",
        " está",
        " um",
        " texto.",
        "."
    ]
}
```

Para utilizar o DeepScan é necessário uma chave de cada uma das APIs que deve ser inserida nos arquivos _imagedetector.dart_ e _textdetector.dart_.
