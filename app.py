from flask import Flask, request, jsonify
import psycopg2
import requests

app = Flask(__name__)

try:
    conn = psycopg2.connect('dbname=deepscan user=postgres password=3f@db host=164.90.152.205 port=80') #padrão 5432, 80 não bloqueia aqui
    print("Conexão com o banco de dados local estabelecida com sucesso")
except Exception as e:
    print("Erro ao conectar ao banco de dados local", e)
    exit(1)

@app.route("/consultarimagem/<hash>", methods=["GET"])
def consultar_imagem(hash):
    print('chegou')
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM imagens WHERE hash = %s", (hash,))
    print('achou')
    resultado = cursor.fetchone()
    print(resultado)
    if resultado:
        print(resultado)
        resultado_map = {
            'id': resultado[0],
            'hash': resultado[1],
            'ai': resultado[2],
            'deep': resultado[3]
        }
        print(resultado_map)
        return jsonify(resultado_map)
    print('retornou false')
    return jsonify({'encontrado': False})

@app.route("/adicionarimagem", methods=["POST"])
def adicionar_imagem():
    try:
        dados = request.json
        hash_img = dados.get("hash")
        ia_val = dados.get("ia")
        deep_val = dados.get("deep")


        cursor = conn.cursor()
        cursor.execute(
            """
            INSERT INTO imagens (hash, ia, deep)
            VALUES (%s, %s, %s)
            """,
            (hash_img, ia_val, deep_val)
        )
        conn.commit()
        cursor.close()

        return jsonify({"mensagem": "Imagem adicionada com sucesso"}), 201

    except Exception as e:
        print(e)
        return jsonify({"erro": str(e)}), 500

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)

    #Ver se o Guilherme consegue hospedar a minha api no servidor dele