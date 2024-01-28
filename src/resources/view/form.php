<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Curso de Slim Framework 4</title>
</head>
<body>
    <form action="/post" method="post">
    Cor: <input type="color" name="color" id=""><br>
    Nome: <input type="text" name="name" id=""><br>
    Gênero: a <input type="radio" name="g" id="" value="a"> o <input type="radio" name="g" id="" value="o"> e <input type="radio" name="g" id="" value="e"> @ <input type="radio" name="g" id="" value="@"><br>
    <input type="submit" value="Enviar">
    </form>
</body>
<?php if(isset($data['color'])){?>
<script>
    document.getElementById('title').style.color = "<?= htmlspecialchars($data['color']); ?>";
</script>
<?php } ?>
</html>