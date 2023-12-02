<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Curso de Slim Framework 4</title>
</head>
<body>
    <h1 id="title">Bem vindo <?= $data['name'] ?>!</h1>    
</body>
<?php if(isset($data['color'])){?>
<script>
    document.getElementById('title').style.color = "<?= $data['color']; ?>";
</script>
<?php } ?>
</html>