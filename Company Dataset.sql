SELECT * FROM project.`company dataset_employees`;
#correct all the date from text to date data_type
SELECT STR_TO_DATE(birth_date, '%m/%d/%Y') FROM project.`company dataset_employees`
SELECT STR_TO_DATE(hire_date, '%m/%d/%Y') FROM project.`company dataset_employees`

#update the hire_date 
ALTER TABLE  project.`company dataset_employees`
ADD COLUMN hire_date_corrected DATE

SET SQL_SAFE_UPDATES = 0

UPDATE project.`company dataset_employees`
SET hire_date_corrected = STR_TO_DATE(hire_date, '%m/%d/%Y') 

ALTER TABLE project.`company dataset_employees` DROP hire_date

ALTER TABLE project.`company dataset_employees`
RENAME COLUMN hire_date_corrected TO hire_date

#Correct the datatype of from_date and to_date in company dataset_dept_employee
ALTER TABLE project.`company dataset_dept_employee` 
ADD COLUMN corrected_from_date DATE,
ADD COLUMN corrected_to_date DATE

UPDATE project.`company dataset_dept_employee` 
SET corrected_from_date = STR_TO_DATE(from_date, '%m/%d/%Y')

UPDATE project.`company dataset_dept_employee` 
SET corrected_to_date = STR_TO_DATE(to_date, '%m/%d/%Y')

ALTER TABLE project.`company dataset_dept_employee` DROP from_date

ALTER TABLE project.`company dataset_dept_employee` DROP to_date

#Rename the corrected columns to take the previous name
ALTER TABLE project.`company dataset_dept_employee` 
RENAME COLUMN corrected_from_date TO from_date,
RENAME COLUMN corrected_to_date TO to_date


#Retrieve the first name and last name of all employees.
SELECT first_name, last_name FROM project.`company dataset_employees`;

#Find the department numbers and names.
SELECT dep_no, dep_name FROM project.`company dataset_department`

# Get the total number of employees.
SELECT COUNT(*) total_employee
FROM  project.`company dataset_employees`;

#Find the average salary of all employees.
SELECT AVG(salary) avg_salary
FROM project.`company dataset_salary`

#Retrieve the birth date and hire date of employee with emp_no 10003.
SELECT birth_date,hire_date 
FROM project.`company dataset_employees`
WHERE emp_no = 10003

#Find the titles of all employees.
SELECT t.title, e.first_name, e.last_name 
FROM project.`company dataset_employeetitle` t
JOIN project.`company dataset_employees` e
ON t.emp_no = e.emp_no

#Get the total number of departments.
SELECT COUNT(*) total_dept
FROM project.`company dataset_department`

#Retrieve the department number and name where employee with emp_no 10004 works
SELECT dep_no, dep_name, de.emp_no
FROM project.`company dataset_department` d
JOIN project.`company dataset_dept_employee` de
ON d.dep_no = de.dept_no
WHERE emp_no = 10004

#Find the gender of employee with emp_no 10007.
SELECT gender FROM project.`company dataset_employees` 
WHERE emp_no = 10007

#Get the highest salary among all employees.
SELECT MAX(salary) AS highest_salary FROM project.`company dataset_salary`

#Retrieve the names of all managers along with their department names.
SELECT e.first_name, e.last_name, d.dep_name, t.title
FROM project.`company dataset_employees` e
JOIN project.`company dataset_deptmanager` dm   
     ON e.emp_no = dm.emp_no
JOIN project.`company dataset_employeetitle` t
     ON e.emp_no = t.emp_no
JOIN project.`company dataset_department` d
     ON d.dep_no = dm.dept_no
WHERE t.title LIKE "%Manager%"

#Find the department with the highest number of employees.
SELECT d.dep_name, COUNT(e.emp_no) total_employee
FROM project.`company dataset_department` d
JOIN project.`company dataset_dept_employee` de
     ON de.dept_no = d.dep_no
JOIN project.`company dataset_employees` e
    ON e.emp_no = de.emp_no
GROUP BY 1
ORDER BY 2 DESC

#Retrieve the employee number, first name, last name, and salary of employees earning more
#than $60,000.
SELECT e.emp_no, e.first_name, e.last_name, s.salary
FROM project.`company dataset_employees` e
JOIN project.`company dataset_salary` s
ON e.emp_no = s.emp_no
WHERE s.salary > 60000
ORDER BY s.salary DESC

#Get the average salary for each department.
SELECT d.dep_name, AVG(s.salary) average_salary
FROM project.`company dataset_salary` s
JOIN project.`company dataset_employees` e
    ON s.emp_no = e.emp_no
JOIN project.`company dataset_dept_employee` de
	ON e.emp_no = de.emp_no
JOIN project.`company dataset_department` d
    ON d.dep_no = de.dept_no
GROUP BY 1

#Retrieve the employee number, first name, last name, and title of all employees who are
#currently managers.
SELECT e.emp_no, e.first_name, e.last_name, t.title
FROM project.`company dataset_employees` e
JOIN project.`company dataset_deptmanager` dm   
     ON e.emp_no = dm.emp_no
JOIN project.`company dataset_employeetitle` t
     ON e.emp_no = t.emp_no
JOIN project.`company dataset_department` d
     ON d.dep_no = dm.dept_no
WHERE t.title LIKE "%Manager%"

#Find the total number of employees in each department.
SELECT d.dep_name, COUNT(e.emp_no) total_employee
FROM project.`company dataset_department` d
JOIN project.`company dataset_dept_employee` de
     ON de.dept_no = d.dep_no
JOIN project.`company dataset_employees` e
    ON e.emp_no = de.emp_no
GROUP BY 1

#Retrieve the department number and name where the most recently hired employee works.
SELECT d.dep_no, d.dep_name, e.hire_date
FROM project.`company dataset_department` d
JOIN project.`company dataset_dept_employee` de
     ON de.dept_no = d.dep_no
JOIN project.`company dataset_employees` e
    ON e.emp_no = de.emp_no
WHERE e.hire_date = (SELECT MAX(e.hire_date) FROM project.`company dataset_employees` e)


#Get the department number, name, and average salary for departments with more than 3
#employees.
SELECT d.dep_no ,d.dep_name, AVG(s.salary) average_salary
FROM project.`company dataset_salary` s
JOIN project.`company dataset_employees` e
    ON s.emp_no = e.emp_no
JOIN project.`company dataset_dept_employee` de
	ON e.emp_no = de.emp_no
JOIN project.`company dataset_department` d
    ON d.dep_no = de.dept_no
GROUP BY 1,2
HAVING COUNT(e.emp_no) > 3


#Retrieve the employee number, first name, last name, and title of all employees hired in 2005.
SELECT e.emp_no, e.first_name, e.last_name, t.title
FROM project.`company dataset_employees` e
JOIN project.`company dataset_employeetitle` t
    ON e.emp_no = t.emp_no
WHERE YEAR(e.hire_date) = 2005

#Find the department with the highest average salary.
SELECT d.dep_name, AVG(s.salary) average_salary
FROM project.`company dataset_salary` s
JOIN project.`company dataset_employees` e
    ON s.emp_no = e.emp_no
JOIN project.`company dataset_dept_employee` de
	ON e.emp_no = de.emp_no
JOIN project.`company dataset_department` d
    ON d.dep_no = de.dept_no
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 1

#Retrieve the employee number, first name, last name, and salary of employees hired before the
#year 2005.
SELECT e.emp_no, e.first_name, e.last_name, t.title
FROM project.`company dataset_employees` e
JOIN project.`company dataset_employeetitle` t
    ON e.emp_no = t.emp_no
WHERE YEAR(e.hire_date) < 2005

#Get the department number, name, and total number of employees for departments with a
#female manager.
SELECT d.dep_no, d.dep_name, COUNT(dm.emp_no) total_employee
FROM project.`company dataset_deptmanager` dm
JOIN project.`company dataset_employees` e
	 ON e.emp_no = dm.emp_no
JOIN project.`company dataset_department` d
     ON dm.dept_no = d.dep_no
WHERE e.gender = 'F'
GROUP BY 1,2

#Retrieve the employee number, first name, last name, and department name of employees who
#are currently working in the Finance department.
SELECT e.emp_no, e.first_name, e.last_name, d.dep_name
FROM project.`company dataset_employees` e
JOIN project.`company dataset_dept_employee` de
     ON e.emp_no = de.emp_no
JOIN project.`company dataset_department` d
     ON d.dep_no = de.dept_no
WHERE d.dep_name = 'Finance'

#Find the employee with the highest salary in each department.
SELECT e.first_name, e.last_name, d.dep_name, s.salary
FROM project.`company dataset_employees` e
JOIN project.`company dataset_salary` s
     ON e.emp_no = s.emp_no
JOIN project.`company dataset_dept_employee` de
     ON e.emp_no = de.emp_no
JOIN project.`company dataset_department` d
     ON d.dep_no = de.dept_no
                  JOIN 
                    (SELECT d.dep_no, MAX(s.salary) AS highest_sal
								FROM project.`company dataset_salary` s
								JOIN project.`company dataset_employees` e
									ON e.emp_no = s.emp_no
								JOIN project.`company dataset_dept_employee` de
									ON e.emp_no = de.emp_no
								JOIN project.`company dataset_department` d
									ON d.dep_no = de.dept_no 
							    GROUP BY 1) sal_de
ON sal_de.dep_no =  d.dep_no AND sal_de.highest_sal = s.salary

#Retrieve the employee number, first name, last name, and department name of employees who
#have held a managerial position.
SELECT dm.emp_no, e.first_name, e.last_name, d.dep_name
FROM project.`company dataset_employees` e
JOIN project.`company dataset_deptmanager` dm
     ON e.emp_no = dm.emp_no
JOIN project.`company dataset_department` d
     ON d.dep_no = dm.dept_no

#Get the total number of employees who have held the title "Senior Manager."
SELECT COUNT(emp_no) FROM project.`company dataset_employeetitle`
WHERE title = 'Senior Manager'

#Retrieve the department number, name, and the number of employees who have worked there for more than 5 years.
SELECT d.dep_no, d.dep_name, COUNT(de.emp_no) employee_number
FROM project.`company dataset_department` d
JOIN project.`company dataset_dept_employee` de
ON d.dep_no = de.dept_no
WHERE DATEDIFF(to_date, from_date) > (5 * 365)
GROUP BY 1,2

#Find the employee with the longest tenure in the company.
SELECT e.emp_no, e.first_name, e.last_name, ROUND(DATEDIFF(de.to_date, de.from_date)/365,2) AS difference 
FROM project.`company dataset_dept_employee` de
JOIN project.`company dataset_employees` e
ON de.emp_no = e.emp_no
ORDER BY 4 DESC
LIMIT 1


#Retrieve the employee number, first name, last name, and title of employees whose hire date is
#between '2005-01-01' and '2006-01-01'.
SELECT e.emp_no, e.first_name, e.last_name, t.title
FROM project.`company dataset_employees` e
JOIN project.`company dataset_employeetitle` t
    ON e.emp_no = t.emp_no
WHERE e.hire_date BETWEEN '2005-01-01' AND '2006-01-01'
    
#Get the department number, name, and the oldest employee's birth date for each department
SELECT de.dept_no, e.first_name, e.birth_date
FROM project.`company dataset_dept_employee` de
JOIN project.`company dataset_employees` e
ON de.emp_no = e.emp_no
       JOIN
			(SELECT de.dept_no, MIN(e.birth_date) AS oldest_birth_year
			  FROM project.`company dataset_dept_employee` de
			  JOIN project.`company dataset_employees` e
			  ON de.emp_no = e.emp_no
			  GROUP BY 1) oldest_de
ON de.dept_no = oldest_de.dept_no AND e.birth_date = oldest_de.oldest_birth_year


