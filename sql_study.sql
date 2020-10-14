--���� . ����(s_emp)���̺��� ���� ���� 10 �� ���
-- hint rownom �̿� --> 5���� ������ rownum 1~10
select name �̸�, salary ����
from (select name,salary from s_emp order by 2 desc)
where rownum <=10;





select DISTINCT manager_id
from s_emp
;

select e1.name, e2.name manager
from s_emp e1, s_emp e2
where e1.manager_id = e2.id;

--view Ȯ��
select view_name , text from user_views;
desc user_views;

--13 . View ����
create view vv_emp as
select e.name, e.title, d.name dept_name
from s_emp e, s_dept d
where e.dept_id = d.id;

select * from vv_emp;

--Q. Index ���� �� ���� 
-- s_emp���̺��� �̸� �÷��� �ε����� �߰��Ͻÿ�
create index new_index
on s_emp(mailID);
                                                                                                                                                                                                                         
from user_indexes
where index_name = 'NEW_INDEX';

--Q. Sequence ����
-- s_emp���̺��� �̸��� ȫ�浿, �޿��� 2000, �������� null�� �Է��ϵ�, ����� sequence���� �̿��Ͻÿ�.
insert into s_emp
VALUES(26,'ȫ�浿',null,null,null,null,c_emp_id.nextval,2000,0);
;
-- ���� ������ ������ ��� SEQUENCE ������ ����Ͻÿ�
select *
from user_sequences;

--���������� Ȱ��ȭ/��Ȱ��ȭ
AlTER TAblE emp_113
--enable constraint data_unique;
disable constraint data_unique;
-- Constraint ����
alter table emp_113
drop constraint data_unique;


--�÷� Constraint �߰�
ALTER TABLE EMP_113
ADD constraint data_unique unique (newdata);
commit;
--�������� Ȯ���ϱ�
select *
from SYS.user_constraints
where index_name = 'DATA_UNIQUE'
;
-- �÷� �����ϱ� (MODIFY)
ALTER TABLE EMP_113
MODIFY (newdata varchar2(20));
commit;
--DDL - �÷� �߰��ϱ� (ADD)
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
from user_cons_columns -- S_EMP�� '�÷�����' ���Ѱ˻�
where table_name = 'S_EMP';

select constraint_name, constraint_type, search_condition, r_constraint_name
from user_constraints -- s_emp�� '���̺���' ���Ѱ˻�
where table_name = 'S_EMP';

SELECT object_name  --����ڰ� ������ ��� ���̺� ��ȸ
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

--Q. EML�������� SubQUERY
update s_emp
set dept_id = ( select dept_id
                from s_emp
                where title = '����')
where name = '��âȯ';

insert into emp_113 (id, name, mailid, stat_date)
select id,name,mailid,start_date
from s_emp
where start_date <'16/01/01' ;

--Q. create�������� SubQuery
create table emp_113 (id,name,mailid,start_date)
as select id,name,mailid,start_date
from s_emp
where dept_id = 113;

 --HAVING�������� SubWQuery ����
--Q. ���� ���� ��ձ޿��� �޴� ��å�� ���� �� ��å�� ��� �޿��� ��Ÿ���ÿ�.
select title ��å , avg(salary) ��ձ޿�
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
--4.HAVING �������� SubQUERY
select dept_id, AVG(salary)
from s_emp
group by dept_id
having avg(salary) > (select avg(salary) from s_emp where dept_id = 113);

select avg(salary) from s_emp where dept_id = 113;

--3. From������ subQUERY : �����Ҷ� ���� ���̱�����
select e.name, e.title, d.name
from(
    SELECT name, title, dept_id
    from s_emp
    where title = '���') e, s_dept d
    where e.dept_id = d.id;
    

--2. Multi Row SubQUERY : ���������� ���� ��
select name, dept_id
from s_emp
where dept_id in (select id from s_dept where region_id =3);

select id from s_dept where region_id =3; -- ��2��


--1. Single Row SubQUERY : ���������� ���� ��
select name, title,dept_id
from s_emp
where dept_id = ( select dept_id from s_emp where name= '������'); --��1��


--SET ������ ����
--union : ������
--union all : ������ + ����κ��� ����
--intersect : ������
--minus : ù��° ��������� �ι��� ��������� ������
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
-- Q. ���� �߿� '������' �� ���� ��å�� ������ ����� �̸���
-- ��å, �޿�, �μ���ȣ�� ��Ÿ���ÿ�. (SELF JOIN�� 
select e1.title, e2.salary, e2.dept_id
from s_emp e1, s_emp e2
where e1.name = '������' and e2.title = e1.title
;
 
select name, title, salary, dept_id
from s_emp
where title = 
(select title 
from s_emp
where name = '������')
;

select title 
from s_emp
where name = '������';

--OUTER JOIN 
--Q. ����(S_EMP)���̺�� ��(S_CUSTOMER)���̺��� ����� �̸��� ���, �׸��� �� ���� �̸��� ��Ÿ���ÿ�
-- ��, ���� ���Ͽ� ��㿵������� ������ ��� ���� �̸��� ��Ÿ����, ��������� �������� ����
select e.name ����̸� , e.id ��� , c.name ���̸�
from s_emp e, s_customer c
where e.id(+) = c.sales_rep_id
order by e.id asc
;

select *
from s_customer;

select *
from s_emp;


--NON-EQUIJOIN 
--Q. ���� ���̺�(S_EMP)�� �޿� ���̺�(SALGRADE)�� JOIN�Ͽ� ����� �̸��� �޿�, �׸��� �ش� �޿������ ��Ÿ���ÿ�.
select e.name, e.salary, g.grade �޿����
from s_emp e , salgrade g
where e.salary between g.losal and g.hisal
;

-- Į���� ���̺��� ALIAS ��� 
--Q. ���� ������ �ٹ��ϴ� ����� ���� �� ����� �̸��� �ٹ��ϴ� �μ����� ��Ÿ���ÿ�.
select e.name �����, d.name �μ���,r.name �ٹ����� 
from s_dept d ,s_region r, s_emp e
where d.region_id = 1 and d.region_id = r.id and d.id = e.dept_id
;

--EQUIJOIN 
-- ����(S_EMP)���̺�� �μ�(S_DEPT)���̺��� JOIN�Ͽ�, ����� �̸��� �μ�, �μ����� ��Ÿ���ÿ�
select e.name, e.dept_id, d.name
from s_emp e, s_dept d
where e.dept_id = d.id;

-- GROUP�� SUBGROUP���� ����ȭ �ϱ�

--Q.�� �μ����� �޿��� �ּҰ��� �ִ밪�� ��Ÿ���ÿ�. ��, �ּҰ��� �ִ밪�� ���� �μ��� ������� ���ÿ�
select dept_id, min(salary), max(salary)
from s_emp
group by dept_id
having min(salary) != max(salary)
;


--Q. �� �μ������� ����� ���� �ٹ��ϴ����� ��Ÿ���ÿ�
select dept_id, count(dept_id)
from s_emp
group by dept_id
;


--Q. �� �μ� ������ �� ��å���� �� ���� �ο��� �ִ��� ��Ÿ���ÿ�
select dept_id, title, count(title)
from s_emp
group by dept_id, title
order by dept_id desc;


--Q. �� �μ����� ��å�� ����� �����鿡 ���ؼ��� ��� �޿��� ���Ͻÿ�
select dept_id, avg(salary)
from s_emp
where title = '���'
group by dept_id;


--Q. HAVING �� ����
--�� ��å���� �޿��� ������ ���ϵ� ��å�� ������ ����� �����Ͻÿ�
--��, �޿� ������ 8000���� �̻��� ��å�� ��Ÿ����, �޿� ���տ� ���� ������������ �����Ͻÿ�
select title, sum(salary)
from s_emp
where title != '����'
group by title
having sum(salary) >8000
order by sum(salary) asc;



--Q. �� �μ����� ��� �޿��� ���ϵ� ��� �޿��� 200�̻��� �μ��� ��Ÿ���ÿ�
select dept_id, avg(salary) 
from s_emp
where salary >200
group by dept_id;


--Q. �� ����(region_id)���� �� ���� �μ��� �ִ����� ��Ÿ���ÿ�
select region_id, count(id) 
from s_dept
group by region_id;

--Q. �� �μ��� ��å�� ����� �������� ��� �޿��� ����ؼ� �����ֽÿ�
select dept_id, avg(salary) from s_emp
where title ='���'
group by dept_id;

--Q. �� �μ�(dept_id)�� ��� �޿��� ����ؼ� �����ֽÿ�
select dept_id ,avg(salary) from s_emp
group by dept_id;

