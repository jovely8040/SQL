----------
-- JOIN: 둘이상의 데이블을 합쳐 하나의 큰 테이블로 만드는 방법
----------
-- 데이터의 중복을 최소화(정규화)
-- Foreign Key를 이용하여 참조

-- 먼저 employees와 departments를 확인
DESC employees;
DESC departments;

-- 두 테이블로부터 모든 레코드를 추출: Cartision Product or Cross Join
SELECT first_name, emp.department_id, dept.department_id, department_name
FROM employees emp, departments dept
ORDER BY first_name;

-- 테이블 조인을 위한 조건 부여를 할 수 있다.
SELECT first_name, emp.department_id, dept.department_id, department_name
FROM employees emp, departments dept
WHERE emp.department_id = dept.department_id;

-- 총 몇명의 사원 있는가?  
SELECT COUNT(*) FROM employees; -- 107명
SELECT first_name, emp.department_id, department_name
FROM employees emp, departments dept
WHERE emp.department_id = dept.department_id;  -- 106명

-- department_id가 null인 사원?
SELECT * FROM employees
WHERE department_id IS NULL;

-- USING: 조인할 컬럼을 명시
SELECT first_name, department_name
FROM employees JOIN departments USING (department_id);

-- ON: JOIN의 조건절
SELECT first_name, department_name
FROM employees emp JOIN departments dept
                    ON (emp.department_id = dept.department_id); -- JOIN의 조건 명시
                    
-- Natural JOIN
-- 조건 명시하지 않고, 같은 이름을 가진 컬럼으로 JOIN
-- 용도가 다르지만 같은 이름을 가진 컬럼을 연결할 수 있으므로 주의, 조건 잘 확인하기!
SELECT first_name, department_name
FROM employees NATURAL JOIN departments;
-- -> 잘못된 쿼리

---------------
-- OUTER JOIN
---------------
-- 조건이 만족하는 짝이 없는 튜플도 NULL을 포함하여 결과를 출력
-- 모든 레코드를 출력할 테이블의 위치에따라 LEFT, RIGHT, FULL OUTER JOIN 으로 구분
-- ORACLE의 경우 NULL을 출력할 조건 쪽에 (+)를 명시

-- LEFT OUTER JOIN: 짝이없는 왼쪽 레코드도 null을 포함하여 출력
-- ORACLE SQL
SELECT first_name,
        emp.department_id,
        dept.department_id,
        department_name
FROM employees emp, departments dept
WHERE emp.department_id = dept.department_id (+);

-- ANSI SQL
SELECT emp.first_name,
        emp.department_id,
        dept.department_id,
        dept.department_name
FROM employees emp LEFT OUTER JOIN departments dept
                    ON emp.department_id = dept.department_id;

-- RIGHT OUTER JOIN: 짝이없는 오른쪽 레코드도 null을 포함하여 출력
-- ORACLE SQL
SELECT first_name,
        emp.department_id,
        dept.department_id,
        dept.department_name
FROM employees emp, departments dept 
WHERE emp.department_id (+) = dept.department_id;

-- ANSI SQL
SELECT emp.first_name,
        emp.department_id,
        dept.department_id,
        dept.department_name
FROM employees emp RIGHT OUTER JOIN departments dept
                    ON emp.department_id = dept.department_id; -- JOIN의 조건 명시

-- FULL OUTER JOIN: 양쪽 테이블 레코드 전부를 짝이 없어도 출력에 참여
-- ORACLE SQL
--SELECT emp.first_name,
--        emp.department_id,
--        dept.department_id,
--        dept.department_name
--FROM employees emp, department dept
--WHERE emp.department_id (+) = dept.department_id;
---- -> ORACLE SQL (+) 방식으로는 불가

-- ANSI SQL
SELECT emp.first_name,
        emp.department_id,
        dept.department_id,
        dept.department_name
FROM employees emp FULL OUTER JOIN departments dept
                    ON emp.department_id = dept.department_id; -- JOIN의 조건 명시

--------------
-- SELF JOIN
--------------
-- 자기 자신과 JOIN
-- 동일한 테이블명이 2번 이상 호출되므로 -> alias를 사용할 수 밖에 없는 JOIN
SELECT * FROM employees; -- 107명

-- 사원 정보, 매니저 이름을 함께 출력
-- 방법 1.
SELECT emp.employee_id,
        emp.first_name,
        emp.manager_id,
        man.employee_id,
        man.first_name
FROM employees emp JOIN employees man
                    ON emp.manager_id = man.employee_id
ORDER BY emp.employee_id;
-- 방법 2.
SELECT emp.employee_id,
        emp.first_name,
        emp.manager_id,
        man.employee_id,
        man.first_name
FROM employees emp, employees man
WHERE emp.manager_id = man.employee_id (+) -- LEFT OUTER JOIN // 짝이 없어도 출력
ORDER BY emp.employee_id;

-------------
-- 집계 함수
-------------
-- :여러 레코드로부터 데이터를 수집, 하나의 결과 행을 반환

-- count: 갯수 세기
SELECT count(*) FROM employees; -- 특정 컬럼이 아닌 레코드의 갯수를 센다

SELECT count(commision_pct) FROM employees; -- 해당 컬럼이 null이 아닌 갯수
SELECT count(*) FROM employees
WHERE commission_pct IS NOT NULL;

-- sum 합계
-- 급여의 합계
SELECT sum(salary) FROM employees;

-- avg: 평균
-- 급여의 평균
SELECT avg(salary) FROM employees;
-- avg 함수는 null값은 집계에서 제외

-- 사원들의 평균 커미션 비율
SELECT avg(commission_pct) FROM employees; -- 22%
SELECT avg(nvl(commission_pct, 0)) FROM employees; -- 7%
-- -> 통계 자료를 낼 때 null값 주의

-- min/max: 최소값, 최대값
SELECT MIN(salary), MAX(salary), AVG(salary), MEDIAN(salary)
FROM employees;

-- 일반적 오류
SELECT department_id, AVG(salary)
FROM employees;
-- -> AVG(salary)는 집계함수이므로 단일행, 그러므로 department_id와 같이 쓸 수 없음
-- 수정: 집계 함수
SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- 집계 함수를 사용한 SELECT문의 컬럼 목록에는 GROUP BY에 참여한 필드, 집계 함수만 올 수 있음

-- 부서별 평균 급여를 출력
-- 평균 급여가 7000 이상인 부서만 뽑아봅시다.
SELECT department_id, AVG(salary)
FROM employees
WHERE AVG(salary) >= 7000
GROUP BY department_id; -- ERROR
-- -> 집계 함수 실행 이전에 WHERE절을 검사하기 때문에 집계 함수는 WHERE절에서 사용할 수 없음
-- 집계 함수 실행 이후에 조건 검사하려면 HAVING절을 이용

SELECT department_id, ROUND(AVG(salary), 2)
FROM employees
GROUP BY department_id
    HAVING AVG(salary) >= 7000
ORDER BY department_id;

-------------
-- 분석 함수
-------------
--ROLLUP
-- :그룸핑된 결과에 대한 상세 요약을 제공하는 기능
-- 일종의 ITEM Total
SELECT department_id,
        job_id,
        SUM(salary)
FROM employees
GROUP BY ROlLUP(department_id, job_id);

-------------
-- CUBE 함수
-------------
-- Cross Table에 대한 summary를 함께 추출
-- ROLLUP 함수에서 추출되는 Item Total과 함께 Column Total 값을 함께 추출
SELECT department_id, job_id, SUM(salary)
FROM employees
GROUP BY CUBE(department_id, job_id)
ORDER BY department_id;

-------------
-- SUBQUERY
-------------
-- : 하나의 질의문 안에 다른 질의문을 포함하는 형태

-- 전체 사원 중, 급여의 중앙값보다 많이 받는 사원
-- 1. 급여의 중앙값?
SELECT MEDIAN(salary) FROM employees; -- 6200
-- 2. 6200보다 많이 받는 사원?
SELECT first_name, salary FROM employees WHERE salary > 6200;
-- 3. 두 쿼리를 합친다
SELECT first_name, salary FROM employees
WHERE salary > (SELECT MEDIAN(salary) FROM employees);

-- Den 보다 늦게 입사한 사원
-- 1. Den 입사일?
SELECT hire_date FROM employees WHERE firest_name = 'Den'; -- 02/12/07
-- 2. 특정 날짜 이후 입사한 사원?
SELECT first_name, hire_date FROM employees WHERE hire_date >= '02/12/07';
-- 3. 두 쿼리를 합친다
SELECT first_name, hire_date
FROM employees
WHERE hire_date >= (SELECT hire_date FROM employees WHERE first_name = 'Den');

-------------------
-- 다중행 서브 쿼리
-------------------
-- : 서브 쿼리의 결과 레코드가 둘 이상이 나올 때는 단일행 연산자를 사용할 수 없다
-- IN, ANY, ALL, EXISTS 등 집합 연산자를 활용
SELECT salary FROM employees WHERE department_id = 110; -- 2 ROW

SELECT first_name, salary FROM employees
WHERE salary = (SELECT salary FROM employees WHERE department_id = 110); -- ERROR

-- 결과가 다중행이면 집합 연산자를 활용
-- salary = 120008 OR salary = 8300
SELECT first_name, salary FROM employees
WHERE salary IN (SELECT salary FROM employees WHERE department_id = 110);

-- ALL(AND)
-- salary > 120008 AND salary > 8300
SELECT first_name, salary FROM employees
WHERE salary > ALL (SELECT salary FROM employees WHERE department_id = 110);

-- ANY(OR)
-- salary > 120008 OR salary > 8300
SELECT first_name, salary FROM employees
WHERE salary > ANY (SELECT salary FROM employees WHERE department_id = 110);

-- 연습문제: 각 부서별로 최고 급여를 받는 사원을 출력
-- 1. 각 부서의 최고 급여 확인 쿼리
SELECT department_id, MAX(salary) FROM employees
GROUP BY department_id;
-- 2. 서브 쿼리의 결과 (department_id, MAX(salary))
SELECT department_id, employee_id, first_name, salary
FROM employees
WHERE (department_id, salary) IN (SELECT department_id, MAX(salary)
                                    FROM employees
                                    GROUP BY department_id)
ORDER BY department_id;

-- 서브쿼리와 조인
SELECT e.department_id, e.employee_id, e.first_name, e.salary
FROM employees e, (SELECT department_id, MAX(salary) salary
                    FROM employees
                    GROUP BY department_id) sal
WHERE e.department_id = sal.department_id AND
        e.salary= sal.salary
ORDER BY e.department_id;