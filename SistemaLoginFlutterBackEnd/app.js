const express = require("express");
const cors = require("cors");

const app = express();

const PORT = 3000;
const HOST = "0.0.0.0";

app.use(express.json());

app.use(cors());



let usuarios = [
    {
        id: 1,
        nome: "Administrador",
        email: "adm@gmail.com",
        senha: "1234"
    }
];



app.get("/", (req, res) => {

    res.json({
        mensagem: "API funcionando!",
        status: "online"
    });

});



app.get("/usuarios", (req, res) => {

    res.status(200).json(usuarios);

});


app.post("/usuarios", (req, res) => {

    const { nome, email, senha } = req.body;


    if (!nome || !email || !senha) {

        return res.status(400).json({
            mensagem: "Preencha todos os campos."
        });

    }


    const usuarioExiste = usuarios.find(
        (usuario) => usuario.email === email
    );


    if (usuarioExiste) {

        return res.status(400).json({
            mensagem: "Já existe um usuário com esse e-mail."
        });

    }


    const novoUsuario = {

        id: usuarios.length + 1,

        nome: nome,

        email: email,

        senha: senha

    };


    usuarios.push(novoUsuario);


    return res.status(201).json({

        mensagem: "Usuário cadastrado com sucesso.",

        usuario: {
            id: novoUsuario.id,
            nome: novoUsuario.nome,
            email: novoUsuario.email
        }

    });

});


app.post("/login", (req, res) => {

    const { email, senha } = req.body;


    if (!email || !senha) {

        return res.status(400).json({
            mensagem: "Informe o e-mail e a senha."
        });

    }


    const usuarioEncontrado = usuarios.find(

        (usuario) =>
            usuario.email === email &&
            usuario.senha === senha

    );


    if (!usuarioEncontrado) {

        return res.status(401).json({
            mensagem: "E-mail ou senha incorretos."
        });

    }


    return res.status(200).json({

        mensagem: "Login realizado com sucesso.",

        usuario: {

            id: usuarioEncontrado.id,

            nome: usuarioEncontrado.nome,

            email: usuarioEncontrado.email

        }

    });

});

app.use((req, res) => {

    res.status(404).json({
        mensagem: "Rota não encontrada."
    });

});

app.listen(PORT, HOST, () => {

    console.log("");
    console.log("======================================");
    console.log("        API INICIADA COM SUCESSO");
    console.log("======================================");
    console.log("");

    console.log(`Servidor rodando na porta ${PORT}`);
    console.log(`Local: http://localhost:${PORT}`);

});