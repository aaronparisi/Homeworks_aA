PRAGMA foreign_keys = ON;

drop table if exists reply_likes;
drop table if exists question_follows;
drop table if exists question_likes;
drop table if exists replies;
drop table if exists questions;
drop table if exists users;

create table users (
    id integer primary key,
    fname text not null,
    lname text not null
);

create table questions (
    id integer primary key,
    title text not null,
    body text not null,
    author_id integer not null,

    foreign key (author_id) references users(id)
);

create table question_follows (
    question_id integer,
    follower_id integer,

    primary key (question_id, follower_id),
    
    foreign key (question_id) references questions(id),
    foreign key (follower_id) references users(id)
);

create table question_likes (
    question_id integer,
    liker_id integer,

    primary key (question_id, liker_id),

    foreign key (question_id) references questions(id),
    foreign key (liker_id) references users(id)
);

create table replies (
    id integer primary key,
    question_id integer not null,
    parent_id integer,
    body text not null,
    author_id text not null,
    
    foreign key (question_id) references questions(id),
    foreign key (parent_id) references replies(id),
    foreign key (author_id) references users(id)
);

create table reply_likes (
    reply_id integer,
    liker_id integer,

    primary key (reply_id, liker_id),

    foreign key (reply_id) references replies(id),
    foreign key (liker_id) references users(id)
);

insert into users (fname, lname)
values ("Christine", "Parisi");

insert into users (fname, lname)
values ("Larry", "Ruzzo");

insert into users (fname, lname)
values ("Vinny", "Ruzzo");

insert into users (fname, lname)
values ("Adam", "Parisi");

insert into users (fname, lname)
values ("Matthew", "Parisi");

insert into users (fname, lname)
values ("Gerard", "Parisi");

insert into users (fname, lname)
values ("Andrew", "Parisi");

insert into users (fname, lname)
values ("Aaron", "Parisi");

insert into users (fname, lname)
values ("Christopher", "Parisi");

insert into users (fname, lname)
values ("Sarah", "Parisi");

insert into users (fname, lname)
values ("Christopher", "Colombus");

insert into questions (title, body, author_id)
values
    ("What's the difference between HTML and CSS?",
    "I'm pretty sure they're both used for front end development",
    1);

insert into question_follows
values (1, 2);

insert into question_follows
values (1, 3);

insert into replies (question_id, parent_id, body, author_id)
values (
    1,
    null,
    "HTML is hypertext markup language",
    2
);

insert into replies (question_id, parent_id, body, author_id)
values (
    1,
    1,
    "It is used to create content on webpages",
    3
);

insert into replies (question_id, parent_id, body, author_id)
values (
    1,
    2,
    "It uses tags to describe what kind of content it is (eg. image)",
    1
);

insert into replies (question_id, parent_id, body, author_id)
values (
    1,
    null,
    "CSS is Cascading Stylesheets",
    5
);

insert into replies (question_id, parent_id, body, author_id)
values (
    1,
    4,
    "It is used to style the webpages (eg. background color, font, etc)",
    6
);

insert into replies (question_id, parent_id, body, author_id)
values (
    1,
    5,
    "A big part of that is selectors - knowing which HTML tags/elements to which you want certain styles to apply",
    4
);

insert into replies (question_id, parent_id, body, author_id)
values (
    1,
    6,
    "Ugh selectors are the worst",
    9
);

insert into reply_likes
values (7, 10);

insert into replies (question_id, parent_id, body, author_id)
values (
    1,
    6,
    "So CSS and HTML work together on different aspects of the webpage's appearance",
    8
);

insert into questions (title, body, author_id)
values
    ("What is object oriented programming?",
    "Honestly I don't even really understand what programming is lol",
    4);

insert into question_follows
values (2, 5);

insert into question_follows
values (2, 6);

insert into questions (title, body, author_id)
values
    ("What is SQL??",
    "Aren't there enough languages already?  Is it a programming language like Ruby?",
    7);

insert into question_likes
values (3, 8);

insert into question_likes
values (3, 9);

insert into question_likes
values (3, 10);