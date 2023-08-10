drop table titles
select * from titles
CREATE TABLE titles (
    title_id VARCHAR(6) PRIMARY KEY,
    title VARCHAR(50) NOT NULL
);

drop table departments
select * from departments
CREATE TABLE departments (
    dept_no CHAR(4) PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

drop table employees
select * from employees
CREATE TABLE employees (
    emp_no INT NOT NULL,
    emp_title_id VARCHAR(5) NOT NULL,
    birth_date VARCHAR NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    sex CHAR(1) NOT NULL,
    hire_date VARCHAR NOT NULL,
    PRIMARY KEY (emp_no)
);

drop table dept_emp
select * from dept_emp
CREATE TABLE dept_emp (
    emp_no INT NOT NULL,
    dept_no CHAR(4) NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

drop table dept_manager
select * from dept_manager
CREATE TABLE dept_manager (
    dept_no CHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    PRIMARY KEY (dept_no, emp_no)
);

drop table salaries
select * from salaries
CREATE TABLE salaries (
    emp_no INT NOT NULL,
    salary INT NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

----Data Analysis
--List the employee number, last name, first name, sex, and salary of each employee.

SELECT
    e.emp_no,
    e.last_name,
    e.first_name,
    e.sex,
    s.salary
FROM
    employees AS e
INNER JOIN
    salaries AS s
ON
    e.emp_no = s.emp_no;
	
	
----List the first name, last name, and hire date for the employees who were hired in 1986.

SELECT
    first_name,
    last_name,
    hire_date
FROM
    employees
WHERE
    EXTRACT(YEAR FROM hire_date) = 1986;

--The above code did not work, possibly because I set hire_date as VARCHAR instead of date. That was the only way postgres will allow me 
-- to import the csv. I could try changing the date format on the csv or ask the instructor/tuitor for help but running out of time

---List the manager of each department along with their department number, department name, employee number, last name, and first name
SELECT
    dm.dept_no AS department_manager,
    d.dept_name AS department_name,
    dm.emp_no AS employee_number,
    e.last_name,
    e.first_name
FROM
    dept_manager AS dm
JOIN
    departments AS d ON dm.dept_no = d.dept_no
JOIN
    employees AS e ON dm.emp_no = e.emp_no;
	
----List the department number for each employee along with that employee’s employee number, last name, first name, and department name.

SELECT
    de.dept_no AS department_number,
    e.emp_no AS employee_number,
    e.last_name,
    e.first_name,
    d.dept_name AS department_name
FROM
    dept_emp AS de
JOIN
    employees AS e ON de.emp_no = e.emp_no
JOIN
    departments AS d ON de.dept_no = d.dept_no;

---List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT
    first_name,
    last_name,
    sex
FROM
    employees
WHERE
    first_name = 'Hercules' AND last_name LIKE 'B%';
	
-----List each employee in the Sales department, including their employee number, last name, and first name.
SELECT
    e.emp_no AS employee_number,
    e.last_name,
    e.first_name
FROM
    employees AS e
JOIN
    dept_emp AS de ON e.emp_no = de.emp_no
WHERE
    de.dept_no = 'd007';

---List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT
    e.emp_no AS employee_number,
    e.last_name,
    e.first_name,
    d.dept_name AS department_name
FROM
    employees AS e
JOIN
    dept_emp AS de ON e.emp_no = de.emp_no
JOIN
    departments AS d ON de.dept_no = d.dept_no
WHERE
    d.dept_name IN ('Sales', 'Development');
	
---List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT
    last_name,
    COUNT(*) AS frequency
FROM
    employees
GROUP BY
    last_name
ORDER BY
    frequency DESC;