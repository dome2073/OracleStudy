--Q21. S_EMP테이블에서 각 사원의 이름과 급여, 급여등급을 나타내시오
--급여가 4000만원 이상이면 A등급, 3000만원 이상이면 B등급, 2000만원 이상이면 C등급, 1000이상이면 D등급, 1000이하는 E등급 
--(sal_grade테이블 사용하지않고 decode()를 사용할것)

select name, salary, decode(trunc(salary/1000), 0 , 'E', 1, 'D' , 2, 'C', 3, 'B', 'A') 급여등급
from s_emp;

--Q22. 자신의 급여가 자신이 속한 부서의 평균보다 적은 직원에 대해 이름, 급여, 부서 번호를 출력
select name, salary, dept_id
from s_emp outer
where salary < (select avg(salary)
                from s_emp
                where dept_id = outer.dept_id)
;
--부서의 평균
select dept_id, avg(salary)
from s_emp
group by dept_id
;
select * from s_emp;
--Q23.본인의 급여가 각 부서별 평균 급여중 어느 한 부서의 평균급여보다
-- 적은 급여를 받는 직원에 대해 이름, 급여, 부서번호를 출력하세요
select name, salary, dept_id
from s_emp 
where salary < any (select avg(salary) from s_emp group by dept_id)
;
--Q24.본인이 다른 사람의 관리자(manager_id)로 되어있는 직원의 사번, 이름, 직책, 부서번호를 나타내시오

select id, name, title, dept_id
from s_emp e
where exists (select id from s_emp where e.id = manager_id);

--Q25. 직원(s_emp) 테이블에서 이름을 사전순으로 정렬하여 5개의 데이터만 나타내시오.
select name
from    (select name
        from s_emp
        order by 1 asc) 
where rownum <=5
;
                                
                                    
