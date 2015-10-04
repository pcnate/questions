    use stackoverflow;
    
    show tables;
    
    -- create the table for clients
    CREATE TABLE clients ( 
      client_id       INT NOT NULL PRIMARY KEY auto_increment,
      client_name     VARCHAR( 70 ) NOT NULL,
      client_details  TEXT
    )
    engine = myisam
    DEFAULT charset=latin1;
    
    -- create the table for parts
    CREATE TABLE parts ( 
      part_id         INT NOT NULL PRIMARY KEY auto_increment,
      part_name       VARCHAR( 70 ) NOT NULL,
      part_cost       NUMERIC( 15,2 ),
      description     TEXT
    )
    engine = myisam
    DEFAULT charset=latin1;
    
    -- create the table for invoices
    CREATE TABLE invoices ( 
      invoice_id      INT NOT NULL PRIMARY KEY auto_increment,
      client_id       INT NOT NULL,
      invoice_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      details         TEXT,
      signer          VARCHAR ( 70 ) NOT NULL
    )
    engine = myisam
    DEFAULT charset=latin1;
    
    -- create table to connect parts to invoices
    CREATE TABLE invoice_parts (
      id              INT NOT NULL PRIMARY KEY auto_increment,
      part_id         INT NOT NULL,
      invoice_id      INT NOT NULL,
      quantity        INT NOT NULL,
      notes           TEXT
    )
    engine = myisam
    DEFAULT charset=latin1;
    
    -- add some clients
    INSERT INTO `clients`
    (`client_id`, `client_name`, `client_details`)
    VALUES
    (NULL, 'chad barker', 'some guy named chad'),
    (NULL, 'leon tester', 'some guy named leon');
    
    -- add some parts
    INSERT INTO `parts`
    (`part_id`, `part_name`, `part_cost`, `description`)
    VALUES
    (NULL, 'can of awesome', '1.99', 'awesome can of awesome'),
    (NULL, 'can of fail', '.25', 'can filled with failure'),
    (NULL, 'box of blocks', '24.99', 'box full of cube shaped items called blocks'),
    (NULL, 'bag of air', '3.99', 'reusable bag filled with useless air');
    
    -- add some invoices
    INSERT INTO `invoices`
    (`invoice_id`, `client_id`, `invoice_date`, `details`, `signer`)
    VALUES
    (NULL, '1', CURRENT_TIMESTAMP, 'there was an order for some stuff', ''),
    (NULL, '1', CURRENT_TIMESTAMP, 'more stuff needed now', ''),
    (NULL, '2', CURRENT_TIMESTAMP, 'need some stuff quick', ''),
    (NULL, '2', CURRENT_TIMESTAMP, 'don''t ship, just charge me', '');
    
    -- add some invoice/part connections
    INSERT INTO `invoice_parts`
    (`part_id`, `invoice_id`, `quantity`, `notes`)
    VALUES
    ('3', '1', '3', 'nothing special'),
    ('2', '1', '2', 'wants blue'),
    ('4', '2', '32', 'wants every color'),
    ('3', '2', '31', 'wants clear'),
    ('2', '3', '12', 'wants blue'),
    ('1', '4', '2', 'wants every color'),
    ('1', '1', '3', 'nothing special'),
    ('2', '1', '2', 'wants blue'),
    ('3', '2', '22', 'wants every color'),
    ('4', '2', '3', 'wants clear'),
    ('2', '3', '12', 'wants blue'),
    ('3', '4', '2', 'wants every color');
    
    -- query the invoice information
    SELECT
      c.client_name,
      i.invoice_date,
      i.details,
      i.signer
    FROM invoices i
    INNER JOIN clients c
    ON i.client_id = c.client_id
    WHERE i.invoice_id = 1
    ;
    
    -- query the list of parts
    SELECT
      ip.invoice_id,
      p.part_id,
      p.part_name,
      p.part_cost,
      ip.quantity,
      p.part_cost * ip.quantity as total
    FROM invoice_parts ip
    INNER JOIN parts p
    ON ip.part_id = p.part_id
    WHERE ip.invoice_id = 1;
    
    -- query the total cost of invoice
    SELECT
      ip.invoice_id,
      SUM( p.part_cost * ip.quantity ) as invoice_total
    FROM invoice_parts ip
    INNER JOIN parts p
    ON ip.part_id = p.part_id
    WHERE ip.invoice_id = 1;
    
    -- query by month
    SELECT
      month( i.invoice_date ) as month,
      count( distinct ip.invoice_id ) as invoices,
      count( * ) as parts,
      p.part_cost * ip.quantity as total
    FROM invoices i
    INNER JOIN invoice_parts ip
    ON ip.invoice_id = i.invoice_id
    INNER JOIN parts p
    ON ip.part_id = p.part_id
    WHERE i.client_id = 2
    AND month( i.invoice_date ) = 5;
    
    -- query by month
    SELECT
      year( i.invoice_date ) as year,
      count( distinct ip.invoice_id ) as invoices,
      count( * ) as parts,
      p.part_cost * ip.quantity as total
    FROM invoices i
    INNER JOIN invoice_parts ip
    ON ip.invoice_id = i.invoice_id
    INNER JOIN parts p
    ON ip.part_id = p.part_id
    WHERE i.client_id = 1
    AND year( i.invoice_date ) = 2014;
    
