import json

# Exemplo de dados de pedidos
pedidos = [
    {
        "numero_pedido": "001",
        "itens": [
            {"produto": "Camiseta", "quantidade": 2},
            {"produto": "Calça", "quantidade": 1}
        ],
        "cliente": "João Silva",
        "total": 50.00
    },
    {
        "numero_pedido": "002",
        "itens": [
            {"produto": "Tênis", "quantidade": 1},
            {"produto": "Meias", "quantidade": 3}
        ],
        "cliente": "Maria Souza",
        "total": 120.00
    }
]

# Salvar os dados em um arquivo JSON
with open('pedidos.json', 'w') as f:
    json.dump(pedidos, f, indent=4)
