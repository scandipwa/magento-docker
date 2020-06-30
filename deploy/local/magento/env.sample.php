<?php
return [
    'install' =>
        [
            'date' => 'Thu, 10 May 2018 09:09:15 +0000',
        ],
    'cache_types' => [
        'config' => 1,
        'layout' => 1,
        'block_html' => 1,
        'collections' => 1,
        'reflection' => 1,
        'db_ddl' => 1,
        'eav' => 1,
        'customer_notification' => 1,
        'config_integration' => 1,
        'config_integration_api' => 1,
        'full_page' => 1,
        'translate' => 1,
        'config_webservice' => 1
    ],
    'cache' => [
        'persisted-query' => [
            'redis' => [
                'host' => 'redis',
                'scheme' => 'tcp',
                'port' => '6379',
                'database' => '5'
            ]
        ]
    ],
];
