create database pizza_sales_project;
use pizza_sales_project;

create table Customers (
    customer_id int primary key,
    customer_name varchar(100) not null,
    phone varchar(20) not null,
    city varchar(50) not null,
    gender varchar(20) not null,
    registration_date date not null,
    age int not null,
    customer_type varchar(30) not null
);

select count(*) as total_customers
from customers;

create table Pizzas (
    pizza_id int primary key,
    pizza_name varchar(100) not null,
    category varchar(50) not null,
    size varchar(20) not null,
    crust varchar(50) not null,
    price decimal(10,2) not null,
    ingredients varchar(500) not null,
    vegetarian varchar(10) not null
);


create table Orders (
    order_id int primary key,
    customer_id int not null ,
    order_date date not null,
    order_time time not null,
    order_type varchar(30) not null,
    payment_method varchar(30) not null,
    delivery_city varchar(50) not null,
    total_amount decimal(10,2)
);


create table Order_Details (
    order_detail_id int primary key,
    order_id int not null,
    pizza_id int not null,
    quantity int not null,
    unit_price decimal(10,2) not null,
    discount decimal(10,2) not null,
    subtotal decimal(10,2) not null,
    rating decimal(3,2)
);


-- customers and orders
alter table orders
add constraint fk_orders_customer
foreign key (customer_id)
references Customers(customer_id);

-- orders and order_details
alter table order_details
add constraint fk_details_order
foreign key (order_id)
references orders(order_id);

-- pizza and order_details
alter table order_details
add constraint fk_details_pizza
foreign key (pizza_id)
references Pizzas(pizza_id);

select * from customers;
----------------- easy ----------------------
-- 1) Find the total number of customers in the Customers table. 
select count(*) as total_customers 
from customers;

-- 2) display the first 1000 customers from the Customers table. 
select * from customers
limit 1000;


-- 3) Display all pizzas that belong to the Vegetarian category. 
select * from pizzas;
select pizza_id,pizza_name,category
from pizzas
where vegetarian = 'Yes';

-- 4) Find the total number of pizzas available in the Pizzas table.
select count(*) as total_pizzas
from pizzas;

-- 5) Display all pizzas having a price greater than 500. 
select pizza_id,pizza_name,size,price
from pizzas
where price > 500;

-- 6) Find the average age of customers. 
select avg(age) as average_age
from customers;

-- 7) Display customers who belong to the city 'Pune'. 
select customer_name,city
from customers
where city = 'pune';

-- 8) Find the maximum and minimum pizza price. 
select 
 max(price) as maximum_price,
min(price) as minimum_price
from pizzas;
 
--  9) Display all orders where the payment method is 'UPI'. 
select * from orders;
select order_id,order_type,delivery_city,payment_method
from orders
where payment_method = 'upi';

-- 10) Find the total sales amount from the Orders table. 
select sum(total_amount) as total_sale
from orders;

------------------- medium-----------------------------------
-- 11) Find the number of customers in each city where city is chennai. 
 select * from customers;
select city,
count(*) as total_customers
from customers 
group by city
having city = 'chennai';

-- 12) Find the average pizza price for each pizza category.
select * from pizzas;
select category,
avg(price) as average_price
from pizzas
group by category; 


-- 13) Find the total sales amount for each payment method.
select * from orders;
select payment_method,
sum(total_amount) as total_sales
from orders
group by payment_method;
 
-- 14) Find the number of orders for each order type such as Delivery, Takeaway, and Dine-in. 
select order_type,
count(*) as total_order
from orders
group by order_type;


-- 15) Find the total quantity of pizzas sold from Order_Details.
select * from order_details;
select sum(quantity) as total_pizzas_sold
from order_details; 

  
-- 16) Find the top 5 most expensive pizzas. 
select * from pizzas;
select pizza_id,pizza_name,category,size,crust,price
from pizzas order by price desc
limit 5;

-- 17) Find the total sales for each delivery city.
select delivery_city,sum(total_amount) as total_sales
from orders group by delivery_city; 


-- 18) Display the customer name, order ID, order date, and total amount using Customers and Orders. 
select * from customers;     select * from orders;
select c.customer_name,o.order_id,o.order_date,o.total_amount
from customers c
inner join orders o
on c.customer_id = o.customer_id;

-- 19) Display the pizza name, category, quantity, and subtotal using Pizzas and Order_Details. 
select * from pizzas;  select * from  Order_Details;
select p.pizza_name,p.category,od.quantity,od.subtotal
from pizzas p
inner join order_details od
on p.pizza_id = od.pizza_id;

-- 20) Find customers who have placed at least one order, displaying their customer name and number of orders. 
select * from customers;  select * from orders;
select c.customer_name, 
count(o.order_id) as number_of_orders
from customers c inner join orders o
on c.customer_id = o.customer_id
group by c.customer_id = c.customer_name;

--------------------------- hard ----------------------------------
-- 21) Find the top 5 customers based on their total spending. 
select * from customers;  select * from orders;
select c.customer_id,c.customer_name,
sum(o.total_amount) as total_spending from customers c
inner join orders o
on c.customer_id = o.customer_id
group by c.customer_id,c.customer_name
order by total_spending desc limit 5;

-- 22) Find customers who have placed at least one order.
select * from customers;  select * from orders;
select customer_id,customer_name,city,age,customer_type
from customers
 where customer_id in ( select customer_id
from orders);

-- 23) Find pizzas whose price is greater than the average pizza price.
select * from pizzas;
select pizza_id,pizza_name,category,size,price
from pizzas
where price > (select avg(price) from pizzas);

-- 24) Find orders whose total amount is greater than the average order amount.
select * from orders;
select order_id,customer_id,order_date,order_time,order_type,payment_method,delivery_city,total_amount
from orders
where total_amount > (select avg(total_amount) 
from orders);

-- 25) Find each customer's name, city, number of orders, and total amount spent.
select * from customers;  select * from orders;
select c.customer_id,c.customer_name,c.city,
count(o.order_id) as total_orders,
sum(o.total_amount) as total_spent
from customers c 
inner join orders o 
on c.customer_id = o.customer_id
group by c.customer_id,c.customer_name,c.city
order by total_spent desc
limit 100;

-- 26) Find each customer's orders with a running total of spending.
select * from orders;
select order_id,customer_id,order_date,total_amount,
sum(total_amount) over (partition by customer_id order by order_date,order_id) as
running_total from orders;

