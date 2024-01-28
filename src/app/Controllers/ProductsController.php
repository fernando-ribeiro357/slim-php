<?php

declare(strict_types=1);

namespace App\Controllers;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class ProductsController extends Controller
{
    public function get(Request $request, Response $response, array $args): Response
    {
        $params = $request->getQueryParams();
        // echo "<pre>";
        // var_dump($params);
        // echo "</pre>";
        
        $content = (empty($params))? $this->viewRender->render('form') : $this->viewRender->render('home', $params);
        $response->getBody()->write($content);
        return $response;
    }

    public function post(Request $request, Response $response, array $args): Response
    {
        $params = $request->getParsedBody();
        // echo "<pre>";
        // var_dump($params);
        // echo "</pre>";
        
        $content = (empty($params))? $this->viewRender->render('form') : $this->viewRender->render('home', $params);
        $response->getBody()->write($content);
        return $response;
    }
}
