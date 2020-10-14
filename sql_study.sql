--과제 . 직원(s_emp)테이블에서 연봉 상위 10 명만 출력
-- hint rownom 이용 --> 5개의 데이터 rownum 1~10
select name 이름, salary 연봉
from (select name,salary from s_emp order by 2 desc)
where rownum <=10;





select DISTINCT manager_id
from s_emp
;

select e1.name, e2.name manager
from s_emp e1, s_emp e2
where e1.manager_id = e2.id;

--view 확인
select view_name , text from user_views;
desc user_views;

--13 . View 생성
create view vv_emp as
select e.name, e.title, d.name dept_name
from s_emp e, s_dept d
where e.dept_id = d.id;

select * from vv_emp;

--Q. Index 생성 및 삭제 
-- s_emp테이블의 이름 컬럼에 인덱스를 추가하시오
create index new_index
on s_emp(mailID);
                                                                                                                                                                                                                         
from user_indexes
where index_name = 'NEW_INDEX';

--Q. Sequence 예제
-- s_emp테이블에서 이름은 홍길동, 급여는 2000, 나머지는 null을 입력하되, 사번은 sequence값을 이용하시오.
insert into s_emp
VALUES(26,'홍길동',null,null,null,null,c_emp_id.nextval,2000,0);
;
-- 현재 유저가 소유한 모든 SEQUENCE 정보를 출력하시오
select *
from user_sequences;

--제약조건의 활설화/비활성화
AlTER TAblE emp_113
--enable constraint data_unique;
disable constraint data_unique;
-- Constraint 삭제
alter table emp_113
drop constraint data_unique;


--컬럼 Constraint 추가
ALTER TABLE EMP_113
ADD constraint data_unique unique (newdata);
commit;
--제약조건 확인하기
select *
from SYS.user_constraints
where index_name = 'DATA_UNIQUE'
;
-- 컬럼 수정하기 (MODIFY)
ALTER TABLE EMP_113
MODIFY (newdata varchar2(20));
commit;
--DDL - 컬럼 추가하기 (ADD)
ALTER TABLE EMP_113
ADD (newdata varchar2(10));
commit;

--Object / Sequence create 
create sequence c_emp_id
increment by 1
start with 26
maxvalue 99999999
nocache
nocycle;

--Dictionary 
select constraint_name, column_name 
from user_cons_columns -- S_EMP의 '컬럼레벨' 제한검색
where table_name = 'S_EMP';

select constraint_name, constraint_type, search_condition, r_constraint_name
from user_constraints -- s_emp의 '테이블레벨' 제한검색
where table_name = 'S_EMP';

SELECT object_name  --사용자가 소유한 모든 테이블 조회
from user_objects
where object_type = 'TABLE' ; 

select *
from dictionary
where table_name like 'USER%' ; 

select *
from dictionary ;

DESC dictionary;

--E.9 TRANSACTION 


rollback;

--Q. EML문에서의 SubQUERY
update s_emp
set dept_id = ( select dept_id
                from s_emp
                where title = '사장')
where name = '안창환';

insert into emp_113 (id, name, mailid, stat_date)
select id,name,mailid,start_date
from s_emp
where start_date <'16/01/01' ;

--Q. create절에서의 SubQuery
create table emp_113 (id,name,mailid,start_date)
as select id,name,mailid,start_date
from s_emp
where dept_id = 113;

 --HAVING절에서의 SubWQuery 예제
--Q. 가장 적은 평균급여를 받는 직책에 대해 그 직책과 평균 급여를 나타내시오.
select title 직책 , avg(salary) 평균급여
from s_emp
group by title
having avg(salary) in (select min(avg(salary)) from s_emp group by title)
;
select min(avg(salary)) from s_emp group by title;


select avg(salary)
from s_emp
group by title
;
--subSuery
--4.HAVING 절에서의 SubQUERY
select dept_id, AVG(salary)
from s_emp
group by dept_id
having avg(salary) > (select avg(salary) from s_emp where dept_id = 113);

select avg(salary) from s_emp where dept_id = 113;

--3. From절에서 subQUERY : 조인할때 수를 줄이기위해
select e.name, e.title, d.name
from(
    SELECT name, title, dept_id
    from s_emp
    where title = '사원') e, s_dept d
    where e.dept_id = d.id;
    

--2. Multi Row SubQUERY : 서브쿼리가 여러 행
select name, dept_id
from s_emp
where dept_id in (select id from s_dept where region_id =3);

select id from s_dept where region_id =3; -- 행2개


--1. Single Row SubQUERY : 서브쿼리가 단일 행
select name, title,dept_id
from s_emp
where dept_id = ( select dept_id from s_emp where name= '김정미'); --행1개


--SET 연산자 예시
--union : 합집합
--union all : 합집합 + 공통부분을 더함
--intersect : 교집합
--minus : 첫번째 쿼리결과와 두번재 쿼리결과의 차집합
select name, dept_id, title
from s_emp
where dept_id = 110
union
select name, dept_id, title
from s_emp
where dept_id = 113
order by 1
;


--SELF JOIN
-- Q. 직원 중에 '김정미' 와 같은 직책을 가지는 사원의 이름과
-- 직책, 급여, 부서번호를 나타내시오. (SELF JOIN을 
select e1.title, e2.salary, e2.dept_id
from s_emp e1, s_emp e2
where e1.name = '김정미' and e2.title = e1.title
;
 
select name, title, salary, dept_id
from s_emp
where title = 
(select title 
from s_emp
where name = '김정미')
;

select title 
from s_emp
where name = '김정미';

--OUTER JOIN 
--Q. 직원(S_EMP)테이블과 고객(S_CUSTOMER)테이블에서 사원의 이름과 사번, 그리고 각 담당고객 이름을 나타내시오
-- 단, 고객에 대하여 담담영업사원이 없더라도 모든 고객의 이름을 나타내고, 사번순으로 오름차순 정렬
select e.name 사원이름 , e.id 사번 , c.name 고객이름
from s_emp e, s_customer c
where e.id(+) = c.sales_rep_id
order by e.id asc
;

select *
from s_customer;

select *
from s_emp;


--NON-EQUIJOIN 
--Q. 직원 테이블(S_EMP)과 급여 테이블(SALGRADE)을 JOIN하여 사원의 이름과 급여, 그리고 해당 급여등급을 나타내시오.
select e.name, e.salary, g.grade 급여등급
from s_emp e , salgrade g
where e.salary between g.losal and g.hisal
;

-- 칼럼과 테이블의 ALIAS 사용 
--Q. 서울 지역에 근무하는 사원에 대해 각 사원의 이름과 근무하는 부서명을 나타내시오.
select e.name 사원명, d.name 부서명,r.name 근무지역 
from s_dept d ,s_region r, s_emp e
where d.region_id = 1 and d.region_id = r.id and d.id = e.dept_id
;

--EQUIJOIN 
-- 직원(S_EMP)테이블과 부서(S_DEPT)테이블을 JOIN하여, 사원의 이름과 부서, 부서명을 나타내시오
select e.name, e.dept_id, d.name
from s_emp e, s_dept d
where e.dept_id = d.id;

-- GROUP을 SUBGROUP으로 세분화 하기

--Q.각 부서별로 급여의 최소값과 최대값을 나타내시오. 단, 최소값과 최대값이 같은 부서는 출력하지 마시오
select dept_id, min(salary), max(salary)
from s_emp
group by dept_id
having min(salary) != max(salary)
;


--Q. 각 부서내에서 몇명의 직원 근무하는지를 나타내시오
select dept_id, count(dept_id)
from s_emp
group by dept_id
;


--Q. 각 부서 내에서 각 직책별로 몇 명의 인원이 있는지 나타내시오
select dept_id, title, count(title)
from s_emp
group by dept_id, title
order by dept_id desc;


--Q. 각 부서별로 직책이 사원인 직원들에 대해서만 평균 급여를 구하시오
select dept_id, avg(salary)
from s_emp
where title = '사원'
group by dept_id;


--Q. HAVING 절 예제
--각 직책별로 급여의 총합을 구하되 직책이 부장인 사람은 제외하시오
--단, 급여 총합이 8000만원 이상인 직책만 나타내며, 급여 총합에 대한 오름차순으로 정렬하시오
select title, sum(salary)
from s_emp
where title != '부장'
group by title
having sum(salary) >8000
order by sum(salary) asc;



--Q. 각 부서별로 평균 급여를 구하되 평균 급여가 200이상인 부서만 나타내시오
select dept_id, avg(salary) 
from s_emp
where salary >200
group by dept_id;


--Q. 각 지역(region_id)별로 몇 개의 부서가 있는지를 나타내시오
select region_id, count(id) 
from s_dept
group by region_id;

--Q. 각 부서별 직책이 사원인 직원들의 평균 급여를 계산해서 보여주시오
select dept_id, avg(salary) from s_emp
where title ='사원'
group by dept_id;

--Q. 각 부서(dept_id)별 평균 급여를 계산해서 보여주시오
select dept_id ,avg(salary) from s_emp
group by dept_id;

