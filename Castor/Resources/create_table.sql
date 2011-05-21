/* 
  create_table.sql
  Castor

  Created by Nobuyuki Matsui on 11/05/06.
  Copyright 2011 __MyCompanyName__. All rights reserved.
*/

create table room_icon_cache (
  room_id          integer not null,
  icon             blob    not null,
  size             integer not null,
  cached_at        real    not null,
  primary key(room_id)
);

create table participation_icon_cache (
  room_id          integer not null,
  participation_id integer not null,
  icon             blob    not null,
  size             integer not null,
  cached_at        real    not null,
  primary key(room_id, participation_id)
);

create table home_timeline_cache (
  pseud_id         integer not null,
  timeline         blob    not null,
  size             integer not null,
  cached_at        real    not null,
  primary key(pseud_id)
);

create table room_list_cache (
  pseud_id         integer not null,
  list             blob    not null,
  size             integer not null,
  cached_at        real    not null,
  primary key(pseud_id)
);

create table room_timeline_cache (
  room_id          integer not null,
  timeline         blob    not null,
  size             integer not null,
  cached_at        real    not null,
  primary key(room_id)
);

create table entries_cache (
  room_id          integer not null,
  entry_id         integer not null,
  entries          blob    not null,
  size             integer not null,
  cached_at        real    not null,
  primary key(room_id, entry_id)
);
