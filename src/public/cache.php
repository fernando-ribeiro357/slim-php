<?php return array (
  0 => 
  array (
    'GET' => 
    array (
      '/' => 'route0',
    ),
    'DELETE' => 
    array (
      '/' => 'route2',
    ),
    'POST' => 
    array (
      '/' => 'route3',
      '/with-body' => 'route6',
    ),
    'PUT' => 
    array (
      '/' => 'route4',
    ),
    'PATCH' => 
    array (
      '/' => 'route5',
    ),
  ),
  1 => 
  array (
    'GET' => 
    array (
      0 => 
      array (
        'regex' => '~^(?|/route/([^/]+))$~',
        'routeMap' => 
        array (
          2 => 
          array (
            0 => 'route1',
            1 => 
            array (
              'id' => 'id',
            ),
          ),
        ),
      ),
    ),
  ),
);