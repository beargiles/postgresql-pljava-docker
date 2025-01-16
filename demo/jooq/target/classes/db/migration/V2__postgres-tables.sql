/*
 * Copyright (c) 2025 Bear Giles <bgiles@coyotesong.com>.
 * All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

--
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--    http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

create table deb_release
(
    id            serial not null,
    apt_filename  text   not null,
    architectures text[] not null,
    components    text[] not null,
    "date"        text,
    "label"       text   not null,
    origin        text   not null,
    suite         text   not null,

    codename      text,
    description   text,
    "version"     text,

    constraint deb_release_pkey primary key (id)
);

create table deb_package_info
(
    id           serial not null,
    package      text   not null,
    format       text   not null,
    category     text   not null,
    section      text   not null,
    priority     text   not null,
    architecture text,
    profile      text,
    essential    boolean,
    protected    boolean,

    constraint deb_package_info_pkey primary key (id)
);

create table deb_source
(
    id                         serial not null,
    apt_filename               text   not null,
    architectures              text[] not null,
    binaries                   text[] not null, -- CSV of simple names
    "date"                     text,
    directory                  text   not null,
    "format"                   text   not null,
    maintainer                 text   not null,
    package                    text   not null,
    section                    text   not null,
    version                    text   not null,
    description                text,
    homepage                   text,
    priority                   text,
    autobuild                  boolean,
    build_conflicts            text[],
    build_conflicts_indep      text[],
    build_depends              text[],
    build_depends_arch         text[],
    build_depends_indep        text[],
    build_indep_architecture   text[],
    go_import_path             text[],
    original_maintainer        text,
    python_version             text,            -- null, 'all' (4), 'current' (1)
    ruby_versions              text,            -- null, 'all' (1143)
    standards_version          text,
    testsuite                  text[],
    ubuntu_nvidia_dependencies text[],
    uploaders                  text,
    vcs_browser                text,
    vcs_bzr                    text,
    vcs_cvs                    text,
    vcs_git                    text,
    vcs_svn                    text,
    vendored_sources_rust      text[],

    constraint deb_source_pkey primary key (id)
);

create table deb_binary
(
    id                  serial not null,
    apt_filename        text   not null,
    architecture        text[] not null,
    "date"              text,
    description         text   not null,
    filename            text   not null,
    maintainer          text   not null,
    package             text   not null,
    size                int8   not null,
    version             text   not null,
    auto_built_package  text[], -- null, 'debug-symbols'
    priority            text,
    section             text,
    source              text,
    homepage            text,
    build_essential     boolean,
    essential           boolean,
    important           boolean,
    protected           text,
    installed_size      text,   -- sometimes int, sometimes 'decimal MB', other?
    origin              text,
    download_size       text,   -- rare, only example is 50.6 MB
    task                text[],
    breaks              text[],
    build_depends       text[],
    conflicts           text[],
    depends             text[],
    enhances            text[],
    pre_depends         text[],
    provides            text[],
    recommends          text[],
    replaces            text[],
    suggests            text[],
    bugs                text,   -- always URL?
    package_type        text,   -- null or 'ddeb'

    build_ids           text[], -- space-separated list of SHA-1 (?)
    built_using         text[], -- comma-separated list of dependencies
    description_md5     text,   -- single md5
    efi_vendor          text,   -- null, 'ubuntu' (2)
    go_import_path      text[],
    license             text,
    multi_arch          text,   -- null, 'foreign' (30541), 'same' (18279), 'allowed' (563), 'no' (3)
    original_maintainer text,
    python_egg_name     text,
    python_version      text,   -- null, 'current' (1), ',' (
    ruby_versions       text,   -- null, 'all' (1672)
    support             text,   -- null, 'PB' (25), 'LTSB' (6), 'NFB' (1)
    vendor              text,

    constraint deb_binary_key primary key (id)
);

create table deb_status
(
    id             serial not null,
    apt_filename   text   not null,
    host           text,
    hostname       text,
    ts             timestamp with time zone,
    status         text   not null,
    architecture   text   not null,
    description    text   not null,
    maintainer     text   not null,
    package        text   not null,
    version        text   not null,
    priority       text,
    section        text,
    source         text,
    homepage       text,
    essential      boolean,
    important      boolean,
    protected      boolean,
    installed_size int8,
    download_size  text,
    breaks         text,
    build_depends  text,
    conflicts      text,
    depends        text,
    enhances       text,
    pre_depends    text,
    provides       text,
    recommends     text,
    replaces       text,
    suggests       text,

    constraint deb_status_pkey primary key (id)
);

create table deb_file_hashes
(
    filename text not null,
    size     int8 not null,
    md5sum   text,
    sha1     text,
    sha256   text,
    sha512   text
);

-- note: we will probably need an n-by-m mapping here.

create table deb_release_file
(
    id         serial not null,
    release_id int4,

    constraint deb_release_files_pkey primary key (id)
) inherits (deb_file_hashes);

create table deb_source_file
(
    id        serial not null,
    source_id int4,

    constraint deb_source_files_pkey primary key (id)
) inherits (deb_file_hashes);

create table deb_binary_file
(
    id        serial not null,
    source_id int4,

    constraint deb_binary_files_pkey primary key (id)
) inherits (deb_file_hashes);
