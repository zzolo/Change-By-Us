# tables

#utility tables
# will be a single row
DROP TABLE IF EXISTS badwords;
CREATE TABLE badwords (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    kill_words TEXT,
    warn_words TEXT,
    updated_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS images;
CREATE TABLE `images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `mirrored` tinyint(1) DEFAULT '0',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `app` (`app`),
  KEY `mirrored` (`mirrored`)
);

#location
drop table if exists location;
create table location (
    location_id int not NULL
    ,name varchar(50) not NULL
    ,lat decimal(9,6) not NULL
    ,lon decimal(9,6) not NULL
    ,borough varchar(50) null
    ,address varchar(100) null
    ,city varchar(50) null
    ,state char(2) null
    ,primary key (location_id)
);

#users
drop table if exists user;
create table user (
    user_id int not null auto_increment
    ,user_key varchar(10) not null
    ,email varchar(100) not NULL
    ,password varchar(255) not NULL
    ,salt varchar(255) not NULL
    ,phone varchar(10) NULL
    ,first_name varchar(50) NULL
    ,last_name varchar(50) NULL
    ,image_id int NULL
    ,location_id int null
    ,description varchar(255) NULL
    ,affiliation varchar(100) null
    ,is_oncall bool not null default 0
    ,email_notification enum('none', 'digest') not null default 'digest'
    ,last_account_page_access_datetime timestamp null
    ,is_active bool not null default 1
    ,created_datetime timestamp not null default '0000-00-00 00:00:00'
    ,updated_datetime timestamp default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP
    ,primary key (user_id)
    ,unique (email)
    ,unique (phone)
);

drop table if exists unauthenticated_user;
create table unauthenticated_user (
    auth_guid char(36) not null
    ,email varchar(100) not NULL
    ,password varchar(255) not NULL
    ,salt varchar(255) not NULL
    ,phone varchar(10) NULL
    ,first_name varchar(50) NULL
    ,last_name varchar(50) NULL
    ,created_datetime timestamp default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP
    ,primary key (auth_guid)
);

create table twitter_user (
    twitter_id int not null
    ,twitter_username varchar(255) not null
    ,user_id int not null references user(user_id)
    ,primary key(user_id)
    ,unique(twitter_id)
);

create table facebook_user (
    facebook_id bigint not null
    ,user_id int not null references user(user_id)
    ,primary key(user_id)
    ,unique(facebook_id)
);

drop table if exists user_group;
create table user_group (
    user_group_id int not null
    ,group_name varchar(50) not NULL
    ,description varchar(255) NULL
    ,is_active bool not null default 1
    ,created_datetime timestamp default CURRENT_TIMESTAMP
    ,primary key (user_group_id)
);

drop table if exists user__user_group;
create table user__user_group (
    user_id int not NULL
    ,user_group_id int not NULL
    ,created_datetime timestamp default CURRENT_TIMESTAMP
    ,primary key (user_id, user_group_id)
);

#ideas
drop table if exists idea;
create table idea (
    idea_id int not null auto_increment
    ,description varchar(255) not NULL
    ,location_id int not null default -1
    ,submission_type enum('web','sms','email') not NULL
    ,user_id int null
    ,email varchar(100) null
    ,phone varchar(10) null
    ,first_name varchar(50) NULL
    ,last_name varchar(50) NULL
    ,num_flags smallint not null default 0
    ,is_active bool not null default 1
    ,created_datetime timestamp default CURRENT_TIMESTAMP
    ,primary key (idea_id)
);

#projects
drop table if exists project;
create table project (
    project_id int not null auto_increment
    ,title varchar(100) not null
    ,description varchar(255) null
    ,image_id int NULL
    ,location_id int null
    ,keywords text null
    ,num_flags smallint not null default 0
    ,is_official bool not null default 0
    ,is_active bool not null default 1
    ,created_datetime timestamp not null default '0000-00-00 00:00:00'
    ,updated_datetime timestamp default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP
    ,primary key (project_id)
);

drop table if exists project__user;
create table project__user (
    project_id int not NULL
    ,user_id int not NULL
    ,is_project_admin bool not null default 0
    ,created_datetime timestamp not null default CURRENT_TIMESTAMP
    ,primary key (project_id, user_id)
);

drop table if exists project__idea;
create table project__idea (
    project_id int not NULL
    ,idea_id int not NULL
    ,created_datetime timestamp not null default CURRENT_TIMESTAMP
    ,primary key (project_id, idea_id)
);

drop table if exists project__project_resource;
create table project__project_resource (
    project_id int not NULL
    ,project_resource_id int not NULL
    ,primary key (project_id, project_resource_id)
    ,created_datetime timestamp not null default CURRENT_TIMESTAMP
);

drop table if exists project_resource;
create table project_resource (
    project_resource_id int not null auto_increment
    ,title varchar(100) not null
    ,description varchar(255) null
    ,url varchar(255) null
    ,twitter_url varchar(255) NULL
    ,facebook_url varchar(255) null
    ,physical_address varchar(255) null
    ,contact_name varchar(255) NULL
    ,contact_email varchar(100) null
    ,contact_user_id int null
    ,image_id int NULL
    ,location_id int null
    ,keywords text null
    ,is_hidden bool not null default 0
    ,is_official bool not null default 0
    ,is_active bool not null default 1
    ,created_datetime timestamp not null default '0000-00-00 00:00:00'
    ,updated_datetime timestamp default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP
    ,primary key (project_resource_id)
);

drop table if exists project__project_resource;
create table project__project_resource (
    project_id int not NULL
    ,project_resource_id int not NULL
    ,created_datetime timestamp not null default CURRENT_TIMESTAMP
    ,primary key (project_id, project_resource_id)
);

drop table if exists project_link;
create table project_link (
    project_link_id int not null auto_increment
    ,project_id int not null
    ,title varchar(100) not null
    ,url varchar(255) not null
    ,image_id int null
    ,num_flags smallint not null default 0
    ,is_active bool not null default 1
    ,created_datetime timestamp not null default CURRENT_TIMESTAMP
    ,primary key (project_link_id)
);

drop table if exists project_goal;
create table project_goal (
    project_goal_id int not null auto_increment
    ,project_id int not null
    ,description varchar(255) not NULL
    ,time_frame_numeric int NULL
    ,time_frame_unit enum('day','week','month') NULL
    ,user_id int null
    ,is_accomplished bool not null default 0
    ,num_flags smallint not null default 0
    ,is_active bool not null default 1
    ,created_datetime timestamp not null default '0000-00-00 00:00:00'
    ,updated_datetime timestamp default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP
    ,primary key (project_goal_id)
);

drop table if exists keyword;
create table keyword (
    keyword varchar(25) not NULL
    ,created_datetime timestamp default current_timestamp
    ,primary key(keyword)
);

# endorsements, messages, and feedback
drop table if exists project_endorsement;
create table project_endorsement (
    project_id int not null
    ,user_id int not null
    ,created_datetime timestamp not null default CURRENT_TIMESTAMP
    ,primary key (project_id, user_id)
);

drop table if exists project_leader;
create table project_leader (
    user_id int not null
    ,title varchar(100)
    ,organization varchar(255)
    ,created_datetime timestamp not null default CURRENT_TIMESTAMP
    ,primary key (user_id)
);

drop table if exists project_message;
create table project_message (
    project_message_id int not null auto_increment
    ,project_id int not null
    ,message varchar(255)
    ,message_type enum('member_comment', 'admin_comment', 'goal_achieved', 'join', 'endorsement') null
    ,idea_id int null
    ,project_goal_id int null
    ,user_id int null
    ,num_flags smallint not null default 0
    ,is_active bool not null default 1
    ,created_datetime timestamp not null default CURRENT_TIMESTAMP
    ,primary key (project_message_id)
);

drop table if exists site_feedback;
create table site_feedback (
    site_feedback_id int not null auto_increment
    ,submitter_name varchar(100) null
    ,submitter_email varchar(100) null
    ,comment text null
    ,is_responded bool not null default 0
    ,responded_user_id int
    ,is_active bool not null default 1
    ,created_datetime timestamp not null default '0000-00-00 00:00:00'
    ,updated_datetime timestamp not null default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP
    ,primary key (site_feedback_id)
);

## featured project

drop table if exists featured_project;
create table featured_project (
    ordinal int not null
    ,project_id int not null
    ,updated_datetime timestamp default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP
    ,primary key (ordinal)
);

## invites
drop table if exists project_invite;
create table project_invite (
    project_invite_id int not null auto_increment
    ,message varchar(255) NULL
    ,project_id int not null
    ,inviter_user_id int not null
    ,invitee_idea_id int null
    ,invitee_user_id int null
    ,invitee_email int null
    ,accepted_datetime timestamp null
    ,created_datetime timestamp not null default CURRENT_TIMESTAMP
    ,primary key (project_invite_id)
);

## sms
drop table if exists sms_stopped_phone;
create table sms_stopped_phone (
    phone varchar(10) not null
    ,created_datetime timestamp not null default CURRENT_TIMESTAMP
    ,primary key (phone)
);

## beta invite stuff
drop table if exists beta_invite_code;
create table beta_invite_code (
    code char(10) not null
    ,user_id int null
    ,created_datetime timestamp not null default CURRENT_TIMESTAMP
    ,primary key(code)
);

drop table if exists beta_invite_request;
create table beta_invite_request (
    beta_invite_request_id int not null auto_increment
    ,email varchar(100) not NULL
    ,comment text NULL
    ,created_datetime timestamp not null default CURRENT_TIMESTAMP
    ,primary key(beta_invite_request_id)
);

## web session
drop table if exists web_session;
CREATE TABLE `web_session` (
  `session_id` char(128) NOT NULL,
  `atime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `data` text,
  UNIQUE KEY `session_id` (`session_id`)
);



## FULL TEXT
alter table idea add fulltext(description);
alter table project add fulltext(title, description);
alter table project_resource add fulltext(title, description);
