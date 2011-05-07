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


