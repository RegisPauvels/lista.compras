# 🛒 Lista de Compras

Aplicativo desenvolvido para gerenciar listas de compras, permitindo a organização de itens por setor, além do controle dos produtos já comprados e dos que ainda estão pendentes.

---

## 📱 Funcionalidades

- Criação e exclusão de listas de compras.
- Adição, edição e exclusão de itens.
- Associação de itens a setores (ex: Hortifruti, Frios, Padaria).
- Marcação de itens como "comprados" ou "pendentes".
- Filtragem de itens por setor.
- Interface simples e intuitiva.

---

## 🧩 Arquitetura

O projeto segue o padrão **MVVM (Model-View-ViewModel)**, garantindo separação de responsabilidades e facilidade de manutenção do código.

- **Model** → Representação das entidades (listas, itens, setores).  
- **ViewModel** → Camada de lógica e comunicação com o banco.  
- **View** → Interface com o usuário (telas, componentes visuais).  

---

## 💾 Persistência de Dados

- **Banco de dados:** SQLite  
- **Acesso:** via serviço centralizado (`BDService`)  
- **Gerenciamento:** CRUD completo para listas, setores e itens  

---

## 🛠️ Tecnologias Utilizadas

- **Linguagem:** Dart  
- **Framework:** Flutter  
- **Banco local:** SQLite  
- **Arquitetura:** MVVM  
- **Gerenciamento de estado:** `setState` e ViewModels  

---

## 🚀 Execução

1. Clone o repositório:
   ```bash
   git clone https://github.com/seuusuario/lista-de-compras.git
2. Instale as dependências:
   ```bash
   flutter pub get
3. Execute o App:
   ```bash
   flutter run

## 👨‍💻 Autor

Regis Ferreira
Aluno do curso de Tecnologia em Sistemas para Internet
Universidade Tecnológica Federal do Paraná (UTFPR)
Disciplina: Desenvolvimento Mobile 2
