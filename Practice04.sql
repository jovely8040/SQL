-- 문제 1.
-- 평균 급여보다 적은 급여을 받는 직원은 몇명인지 구하세요. (56건) COUNT(SALARY)
SELECT COUNT(salary) FROM employees
WHERE salary < (SELECT AVG(salary) FROM employees);


-- 문제 2. 
-- 평균급여 이상, 최대급여 이하의 월급을 받는 사원의
-- 직원번호(employee_id), 이름(first_name), 급여(salary), 평균급여, 최대급여를
-- 급여의 오름차순으로 정렬하여 출력하세요. (51건)
-- 서브 쿼리
SELECT AVG(salary) avgSalary ,MAX(salary) maxSalary FROM employees;
-- 최종 쿼리
SELECT e.employee_id 직원번호,
        e.first_name 이름,
        e.salary 급여,
        t.avgSalary 평균급여,
        t.maxSalary 최대급여
FROM employees e, (SELECT AVG(salary) avgSalary, MAX(salary) maxSalrary FROM employees) t
WHERE e.salary BETWEEN t.avgSalary AND t.maxSalary
ORDER BY salary;


-- 문제 3.
-- 직원중 Steven(first_name) king(last_name)이 소속된 부서(departments)가 있는 곳의 주소를 알아보려고 한다.
-- 도시아이디(location_id), 거리명(street_address), 우편번호(postal_code), 도시명(city),
-- 주(state_province), 나라아이디(country_id) 를 출력하세요. (1건)
-- 1. 이름이 steve king인 사람의 부서 id 를 알아야함
SELECT department_id FROM employees WHERE first_name = 'Steven' AND last_name = 'King'; -- 90
-- 2. steve king이라는 사람이 소속된 부서의 위치 id 값을 알아와야함
SELECT location_id FROM departments WHERE department_id = 90;
-- 3. 최종 쿼리
SELECT * FROM locations WHERE location_id =
(SELECT location_id FROM departments WHERE department_id =
(SELECT department_id FROM employees WHERE first_name = 'Steven' AND last_name = 'King'));


-- 문제 4.
-- job_id 가 'ST_MAN' 인 직원의 급여보다 작은 직원의 사번,이름,급여를 급여의 내림차순으로 출력하세요.
-- -ANY연산자 사용 (74건)
-- 서브 쿼리
SELECT salary FROM employees WHERE job_id = 'ST_MAN';
-- 최종 쿼리
SELECT employee_id 사번, first_name 이름, salary 급여 FROM employees
WHERE salary < ANY (SELECT salary FROM employees WHERE job_id = 'ST_MAN')
ORDER BY salary desc;


-- 문제 5. 
-- 각 부서별로 최고의 급여를 받는 사원의
-- 직원번호(employee_id), 이름(first_name)과 급여(salary) 부서번호(department_id)를 조회하세요.
-- 단 조회결과는 급여의 내림차순으로 정렬되어 나타나야 합니다. 
-- 조건절비교, 테이블조인 2가지 방법으로 작성하세요. (11건)
-- 서브 쿼리: 각 부서의 최고 급여 확인
SELECT department_id, MAX(salary) FROM employees GROUP BY department_id;
-- 최종 쿼리: 조건절 비교
SELECT employee_id, first_name, salary, department_id
FROM employees
WHERE (department_id, salary) IN (SELECT department_id, MAX(salary) FROM employees GROUP BY department_id)
ORDER BY salary DESC;
-- 최종 쿼리: 테이블 조인
SELECT e.department_id, e.employee_id, e.first_name, e.salary
FROM employees e, (SELECT department_id, MAX(salary) salary FROM employees GROUP BY department_id) t
WHERE e.department_id = t.department_id AND e.salary = t.salary
ORDER BY e.salary DESC;


-- 문제 6.
-- 각 업무(job) 별로 연봉(salary)의 총합을 구하고자 합니다. 
-- 연봉 총합이 가장 높은 업무부터 업무명(job_title)과 연봉 총합을 조회하세요. (19건)
-- 서브 쿼리
SELECT job_id, SUM(salary) sumSalary FROM employees GROUP BY job_id;
-- 최종 쿼리
SELECT j.job_title, t.sumSalary
FROM jobs j, (SELECT job_id, SUM(salary) sumSalary FROM employees GROUP BY job_id) t
WHERE j.job_id = t.job_id
ORDER BY t.sumsalary DESC;


-- 문제 7.
-- 자신의 부서 평균 급여보다 연봉(salary)이 많은 직원의
-- 직원번호(employee_id), 이름(first_name)과 급여(salary)을 조회하세요. (38건)
-- 서브 쿼리
SELECT department_id, AVG(salary) salary FROM employees GROUP BY department_id;
-- 최종 쿼리
SELECT e.employee_id 직원번호, e.first_name 이름, e.salary 급여
FROM employees e, (SELECT department_id, AVG(salary) salary FROM employees GROUP BY department_id) t
WHERE e.department_id = t.department_id AND e.salary > t.salary;


-- 문제 8.
-- 직원 입사일이 11번째에서 15번째의 직원의 사번, 이름, 급여, 입사일을 입사일 순서로 출력하세요.
-- 서브 쿼리1
SELECT ROWNUM employee_id, first_name, salary, hire_date FROM employees ORDER BY hire_date ASC;
-- 서브 쿼리2
SELECT ROWNUM rn, employee_id, first_name, salary, hire_date
FROM (SELECT employee_id, first_name, salary, hire_date FROM employees ORDER BY hire_date ASC);
-- 최종 쿼리
SELECT rn, employee_id, first_name, salary, hire_date
FROM (SELECT ROWNUM rn, employee_id, first_name, salary, hire_date
        FROM (SELECT ROWNUM rn, employee_id, first_name, salary, hire_date
                FROM (SELECT employee_id, first_name, salary, hire_date
                        FROM employees ORDER BY hire_date ASC)))
WHERE rn BETWEEN 11 AND 15;

