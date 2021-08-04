-- 문제 1. 
-- 전체직원의 다음 정보를 조회하세요. 정렬은 입사일(hire_date)의 올림차순(ASC)으로 가장 선임부터 출력이 되도록 하세요.
-- 이름(first_name last_name), 월급(salary), 전화번호(phone_number), 입사일(hire_date) 순서이고
-- “이름”, “월급”, “전화번호”, “입사일” 로 컬럼이름을 대체해 보세요.
SELECT first_name || ' ' || last_name 이름 , salary "월 급", phone_number 전화번호, hire_date as 입사일
FROM employees
ORDER BY hire_date ASC; -- 오름차순 정렬


-- 문제2.
-- 업무(jobs)별로 업무이름(job_title)과 최고월급(max_salary)을 월급의 내림차순(DESC)로 정렬하세요.
SELECT MAX(salary)
FROM employees
ORDER BY MAX(salary) DESC;


-- 문제3.
-- 담당 매니저가 배정되어있으나 커미션비율이 없고, 월급이 3000초과인 직원의 이름, 매니저 아이디, 커미션 비율, 월급 을 출력하세요.
SELECT first_name, manager_id, commission_pct, salary
FROM employees
WHERE manager_id IS NOT NULL AND
    commission_pct IS NULL AND
    salary  >= 3000;

SELECT * FROM JOBS;
-- 문제4.
-- 최고월급(max_salary)이 10000 이상인 업무의 이름(job_title)과 최고월급(max_salary)을
-- 최고월급의(max_salary) 내림차순(DESC)로 정렬하여 출력하세요. 
SELECT job_title, max_salary
FROM jobs
WHERE max_salary >= 10000
ORDER BY max_salary DESC;

-- 문제5.
-- 월급이 14000 미만 10000 이상인 직원의 이름(first_name), 월급, 커미션퍼센트를 월급순(내림차순) 출력하세요.
-- 단 커미션퍼센트 가 null 이면 0 으로 나타내세요.
SELECT first_name, salary, commission_pct, salary * nvl(commission_pct, 0) commission
FROM employees
WHERE salary >= 10000 AND salary < 14000
ORDER BY salary DESC; --  내림차순


-- 문제6.
-- 부서번호가 10, 90, 100 인 직원의 이름, 월급, 입사일, 부서번호를 나타내세요.
-- 입사일은 1977-12 와 같이 표시하세요.
SELECT first_name, salary, TO_CHAR(hire_date, 'YYYY-MM'), department_id
FROM employees
WHERE department_id = ANY (10, 20, 30);


-- 문제7.
-- 이름(first_name)에 S 또는 s 가 들어가는 직원의 이름, 월급을 나타내세요.
SELECT first_name, salary
FROM employees
WHERE (first_name LIKE '%S%' OR first_name LIKE '%s%');


-- 문제8.
-- 전체 부서를 출력하려고 합니다. 순서는 부서이름이 긴 순서대로 출력해보세요.
SELECT * FROM employees ORDER BY LENGTH(job_id) DESC;

-- 문제9.
-- 정확하지 않지만, 지사가 있을 것으로 예상되는 나라들을 나라이름을 대문자로 출력하고 올림차순(ASC)으로 정렬해 보세요.
SELECT UPPER(country_name)
FROM countries
ORDER BY country_name;

-- 문제10.
-- 입사일이 03/12/31 일 이전 입사한 직원의 이름, 월급, 전화 번호, 입사일을 출력하세요.
-- 전화번호는 545-343-3433 과 같은 형태로 출력하세요.
SELECT first_name,
        salary,
        REPLACE(phone_number, '.', '-'),
        hire_date
FROM employees, dual
WHERE hire_date <= '03/12/31';
