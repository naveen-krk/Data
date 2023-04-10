USE schema hr;
--1. Write a SQL query to find the total salary of employees who is in Tokyo excluding whose first name is Nancy
select sum(salary) as totalsalary from employee 
inner join 
departments on employee.department_id=departments.department_id
inner join 
locations on departments.location_id=locations.location_id where city='Seattle' and first_name!='Nancy';

--2.Fetch all details of employees who has salary more than the avg salary by each department.
SELECT *
FROM employee e
WHERE e.salary > (
  SELECT AVG(salary)
  FROM employee
  WHERE department_id = e.department_id
)
select avg(salary),department_id from employee group by department_id;
--3.Write a SQL query to find the number of employees and its location whose salary is greater than or equal to 70000 and less than 100000
select * from locations ;
select * from employee;
select * from departments;
select* from jobs;
SELECT l.city, COUNT(e.employee_id) AS num_employees
FROM locations l
INNER JOIN departments d ON l.location_id = d.location_id
INNER JOIN employee e ON d.department_id = e.department_id
WHERE e.salary >= 7000 AND e.salary < 10000
GROUP BY l.city;


--4.Fetch max salary, min salary and avg salary by job and department. Info: grouped by department id and job id ordered by department id and max salary
SELECT 
  e.department_id, 
  e.job_id, 
  MAX(e.salary) AS max_salary, 
  MIN(e.salary) AS min_salary, 
  AVG(e.salary) AS avg_salary
FROM 
  employee e
GROUP BY 
  e.department_id, 
  e.job_id
ORDER BY 
  e.department_id, 
  max_salary DESC;

--5Write a SQL query to find the total salary of employees whose country_id is ‘US’ excluding whose first name is Nancy
SELECT SUM(salary) AS total_salary
FROM employee
JOIN departments ON employee.department_id = departments.department_id
JOIN locations ON departments.location_id = locations.location_id
JOIN countries ON locations.country_id = countries.country_id
WHERE countries.country_id = 'US' AND employee.first_name != 'Nancy';

--6.Fetch max salary, min salary and avg salary by job id and department id but only for folks who worked in more than one role(job) in a department.
select max(salary),min(salary),avg(salary) from employee group by job_id ,department_id having count(employee_id);
SELECT job_id, department_id, MAX(salary) AS max_salary, MIN(salary) AS min_salary, AVG(salary) AS avg_salary 
FROM employee
WHERE department_id IN (
    SELECT department_id 
    FROM employee 
    GROUP BY department_id 
    HAVING COUNT(DISTINCT job_id) > 1
) 
GROUP BY job_id, department_id;


--7.Display the employee count in each department and also in the same result.Info: * the total employee count categorized as "Total" the null department count categorized as "-"
SELECT COALESCE(department_name, '-') AS department_name, COUNT(*) AS employee_count
FROM employee
LEFT JOIN departments
ON employee.department_id = departments.department_id
GROUP BY ROLLUP(department_name);

-- 8.Display the jobs held and the employee count.

-- Hint: every employee is part of at least 1 job

-- Hint: use the previous questions answer

-- Sample

-- JobsHeld EmpCount

-- 1 100

-- 2 4
SELECT job_id AS JobsHeld, COUNT(*) AS EmpCount
FROM employee
GROUP BY job_id;

-- 9.Display average salary by department and country
SELECT d.department_name, l.country_id, AVG(e.salary) AS avg_salary
FROM employee e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
GROUP BY d.department_name, l.country_id;

--10.Display manager names and the number of employees reporting to them by countries (each employee works for only one department, and each department belongs to a country
SELECT l.country_id,m.first_name AS manager_name, COUNT(*) AS employee_count
FROM employee e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
JOIN employee m ON e.manager_id = m.employee_id
GROUP BY l.country_id, m.manager_id;

-- 11.Group salaries of employees in 4 buckets eg: 0-10000, 10000-20000,.. (Like the previous question) but now group by department and categorize it like below.

-- Eg :

-- DEPT ID 0-10000 10000-20000

-- 50 2 10

-- 60 6 5
SELECT d.department_id,
       SUM(CASE WHEN e.salary >= 0 AND e.salary < 10000 THEN 1 ELSE 0 END) as zer0,
       SUM(CASE WHEN e.salary >= 10000 AND e.salary < 20000 THEN 1 ELSE 0 END) as "10000-20000",
       SUM(CASE WHEN e.salary >= 20000 AND e.salary < 30000 THEN 1 ELSE 0 END) as "20000-30000",
       SUM(CASE WHEN e.salary >= 30000 THEN 1 ELSE 0 END) AS ">30000"
FROM employee e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_id;


--12.Display employee count by country and the avg salary

-- Eg :

-- Emp Count Country Avg Salary

-- 10 Germany 34242.8

SELECT COUNT(*) AS EmpCount,
       l.country_id AS Country,
       AVG(e.salary) AS AvgSalary
FROM employee e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
GROUP BY l.country_id;

--13.Display region and the number off employees by department

-- Eg :

-- Dept ID America Europe Asia

-- 10 22 - -

-- 40 - 34 -

-- (Please put "-" instead of leaving it NULL or Empty)
SELECT e.department_id AS "Dept ID",
       (CASE WHEN region_name = 'Americas' THEN count_of ELSE 0 END) AS America,
       sum(CASE WHEN region_name = 'Europe' THEN  count_of else 0 END) AS Europe,
       sum(CASE WHEN region_name = 'Asia' THEN 1 ELSE 0 END) AS Asia
FROM (
select employee.department_id,regions.region_name, count(countries.region_id) as count_of from EMPLOYEE
inner join 
departments on EMPLOYEE.DEPARTMENT_ID=departments.department_id
inner join 
locations on locations.location_id=departments.location_id
inner join
countries on countries.country_id=locations.country_id
inner join 
regions on regions.region_id=countries.region_id
group by employee.department_id , regions.region_name) as e
GROUP BY e.region_name,e.department_id,e.count_of ;


--14.Select the list of all employees who work either for one or more departments or have not yet joined / allocated to any department
SELECT *
FROM employee e
LEFT JOIN departments d
ON e.department_id = d.department_id
WHERE d.department_id IS NULL OR e.department_id IS NOT NULL;


--15.write a SQL query to find the employees and their respective managers. Return the first name, last name of the employees and their managers

SELECT 
    e.first_name AS employee_first_name, 
    e.last_name AS employee_last_name, 
    m.first_name AS manager_first_name, 
    m.last_name AS manager_last_name 
FROM 
    employee e 
    INNER JOIN employee m ON e.manager_id = m.employee_id;

--16.write a SQL query to display the department name, city, and state province for each department.
select * from departments;
select d.department_name,l.city,l.state_province from departments d inner join locations l ON d.location_id=l.location_id;
select * from locations;

--17.write a SQL query to list the employees (first_name , last_name, department_name) who belong to a department or don't
SELECT employee.first_name, employee.last_name, departments.department_name
FROM employee
LEFT JOIN departments ON employee.department_id = departments.department_id;
--18. The HR decides to make an analysis of the employees working in every department. Help him to determine the salary given in average per department and the total number of employees working in a department. List the above along with the department id, department name
SELECT departments.department_id, departments.department_name, 
       AVG(employee.salary) AS average_salary, COUNT(*) AS total_employees
FROM departments
LEFT JOIN employee ON departments.department_id = employee.department_id
GROUP BY departments.department_id, departments.department_name;
--19. Write a SQL query to combine each row of the employees with each row of the jobs to obtain a consolidated results. (i.e.) Obtain every possible combination of rows from the employees and the jobs relation.
SELECT *
FROM employee join jobs;
--20.Write a query to display first_name, last_name, and email of employees who are from Europe and Asia
SELECT e.first_name, e.last_name, e.email
FROM employee e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
JOIN countries c ON l.country_id = c.country_id
JOIN regions r ON c.region_id = r.region_id
WHERE r.region_name LIKE 'Europe' OR r.region_name LIKE 'Asia';

-- 21. Write a query to display full name with alias as FULL_NAME (Eg: first_name = 'John' and last_name='Henry' - full_name = "John Henry") who are from oxford city and their second last character of their last name is 'e' and are not from finance and shipping department.

SELECT CONCAT(first_name, ' ', last_name) AS FULL_NAME
FROM employee
JOIN departments ON employee.department_id = departments.department_id
JOIN locations ON departments.location_id = locations.location_id
JOIN countries ON locations.country_id = countries.country_id
WHERE  locations.city = 'Oxford' 
AND SUBSTR(last_name, -2, 1) = 'e' 
AND departments.department_name NOT IN ('Finance', 'Shipping')

--22.Display the first name and phone number of employees who have less than 50 months of experience
SELECT first_name, phone_number
FROM employee
WHERE DATEDIFF(MONTH, hire_date, GETDATE()) < 50;
--23.Display Employee id, first_name, last name, hire_date and salary for employees who has the highest salary for each hiring year. (For eg: John and Deepika joined on year 2023, and john has a salary of 5000, and Deepika has a salary of 6500. Output should show Deepika’s details only).
SELECT e.employee_id, e.first_name, e.last_name, e.hire_date, e.salary
FROM employee e
WHERE e.salary = (
  SELECT MAX(salary)
  FROM employee
  WHERE YEAR(hire_date) = YEAR(e.hire_date)
) order by hire_date;



