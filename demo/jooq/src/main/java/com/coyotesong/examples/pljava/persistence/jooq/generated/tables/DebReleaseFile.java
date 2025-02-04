/*
 * This file is generated by jOOQ.
 */
package com.coyotesong.examples.pljava.persistence.jooq.generated.tables;


import com.coyotesong.examples.pljava.persistence.jooq.generated.Keys;
import com.coyotesong.examples.pljava.persistence.jooq.generated.Public;
import com.coyotesong.examples.pljava.persistence.jooq.generated.tables.records.DebReleaseFileRecord;

import java.util.Collection;

import org.jooq.Condition;
import org.jooq.Field;
import org.jooq.Identity;
import org.jooq.Name;
import org.jooq.PlainSQL;
import org.jooq.QueryPart;
import org.jooq.SQL;
import org.jooq.Schema;
import org.jooq.Select;
import org.jooq.Stringly;
import org.jooq.Table;
import org.jooq.TableField;
import org.jooq.TableOptions;
import org.jooq.UniqueKey;
import org.jooq.impl.DSL;
import org.jooq.impl.SQLDataType;
import org.jooq.impl.TableImpl;


/**
 * This class is generated by jOOQ.
 */
@SuppressWarnings({ "all", "unchecked", "rawtypes", "this-escape" })
public class DebReleaseFile extends TableImpl<DebReleaseFileRecord> {

    private static final long serialVersionUID = 1L;

    /**
     * The reference instance of <code>public.deb_release_file</code>
     */
    public static final DebReleaseFile DEB_RELEASE_FILE = new DebReleaseFile();

    /**
     * The class holding records for this type
     */
    @Override
    public Class<DebReleaseFileRecord> getRecordType() {
        return DebReleaseFileRecord.class;
    }

    /**
     * The column <code>public.deb_release_file.filename</code>.
     */
    public final TableField<DebReleaseFileRecord, String> FILENAME = createField(DSL.name("filename"), SQLDataType.CLOB.nullable(false), this, "");

    /**
     * The column <code>public.deb_release_file.size</code>.
     */
    public final TableField<DebReleaseFileRecord, Long> SIZE = createField(DSL.name("size"), SQLDataType.BIGINT.nullable(false), this, "");

    /**
     * The column <code>public.deb_release_file.md5sum</code>.
     */
    public final TableField<DebReleaseFileRecord, String> MD5SUM = createField(DSL.name("md5sum"), SQLDataType.CLOB, this, "");

    /**
     * The column <code>public.deb_release_file.sha1</code>.
     */
    public final TableField<DebReleaseFileRecord, String> SHA1 = createField(DSL.name("sha1"), SQLDataType.CLOB, this, "");

    /**
     * The column <code>public.deb_release_file.sha256</code>.
     */
    public final TableField<DebReleaseFileRecord, String> SHA256 = createField(DSL.name("sha256"), SQLDataType.CLOB, this, "");

    /**
     * The column <code>public.deb_release_file.sha512</code>.
     */
    public final TableField<DebReleaseFileRecord, String> SHA512 = createField(DSL.name("sha512"), SQLDataType.CLOB, this, "");

    /**
     * The column <code>public.deb_release_file.id</code>.
     */
    public final TableField<DebReleaseFileRecord, Integer> ID = createField(DSL.name("id"), SQLDataType.INTEGER.nullable(false).identity(true), this, "");

    /**
     * The column <code>public.deb_release_file.release_id</code>.
     */
    public final TableField<DebReleaseFileRecord, Integer> RELEASE_ID = createField(DSL.name("release_id"), SQLDataType.INTEGER, this, "");

    private DebReleaseFile(Name alias, Table<DebReleaseFileRecord> aliased) {
        this(alias, aliased, (Field<?>[]) null, null);
    }

    private DebReleaseFile(Name alias, Table<DebReleaseFileRecord> aliased, Field<?>[] parameters, Condition where) {
        super(alias, null, aliased, parameters, DSL.comment(""), TableOptions.table(), where);
    }

    /**
     * Create an aliased <code>public.deb_release_file</code> table reference
     */
    public DebReleaseFile(String alias) {
        this(DSL.name(alias), DEB_RELEASE_FILE);
    }

    /**
     * Create an aliased <code>public.deb_release_file</code> table reference
     */
    public DebReleaseFile(Name alias) {
        this(alias, DEB_RELEASE_FILE);
    }

    /**
     * Create a <code>public.deb_release_file</code> table reference
     */
    public DebReleaseFile() {
        this(DSL.name("deb_release_file"), null);
    }

    @Override
    public Schema getSchema() {
        return aliased() ? null : Public.PUBLIC;
    }

    @Override
    public Identity<DebReleaseFileRecord, Integer> getIdentity() {
        return (Identity<DebReleaseFileRecord, Integer>) super.getIdentity();
    }

    @Override
    public UniqueKey<DebReleaseFileRecord> getPrimaryKey() {
        return Keys.DEB_RELEASE_FILES_PKEY;
    }

    @Override
    public DebReleaseFile as(String alias) {
        return new DebReleaseFile(DSL.name(alias), this);
    }

    @Override
    public DebReleaseFile as(Name alias) {
        return new DebReleaseFile(alias, this);
    }

    @Override
    public DebReleaseFile as(Table<?> alias) {
        return new DebReleaseFile(alias.getQualifiedName(), this);
    }

    /**
     * Rename this table
     */
    @Override
    public DebReleaseFile rename(String name) {
        return new DebReleaseFile(DSL.name(name), null);
    }

    /**
     * Rename this table
     */
    @Override
    public DebReleaseFile rename(Name name) {
        return new DebReleaseFile(name, null);
    }

    /**
     * Rename this table
     */
    @Override
    public DebReleaseFile rename(Table<?> name) {
        return new DebReleaseFile(name.getQualifiedName(), null);
    }

    /**
     * Create an inline derived table from this table
     */
    @Override
    public DebReleaseFile where(Condition condition) {
        return new DebReleaseFile(getQualifiedName(), aliased() ? this : null, null, condition);
    }

    /**
     * Create an inline derived table from this table
     */
    @Override
    public DebReleaseFile where(Collection<? extends Condition> conditions) {
        return where(DSL.and(conditions));
    }

    /**
     * Create an inline derived table from this table
     */
    @Override
    public DebReleaseFile where(Condition... conditions) {
        return where(DSL.and(conditions));
    }

    /**
     * Create an inline derived table from this table
     */
    @Override
    public DebReleaseFile where(Field<Boolean> condition) {
        return where(DSL.condition(condition));
    }

    /**
     * Create an inline derived table from this table
     */
    @Override
    @PlainSQL
    public DebReleaseFile where(SQL condition) {
        return where(DSL.condition(condition));
    }

    /**
     * Create an inline derived table from this table
     */
    @Override
    @PlainSQL
    public DebReleaseFile where(@Stringly.SQL String condition) {
        return where(DSL.condition(condition));
    }

    /**
     * Create an inline derived table from this table
     */
    @Override
    @PlainSQL
    public DebReleaseFile where(@Stringly.SQL String condition, Object... binds) {
        return where(DSL.condition(condition, binds));
    }

    /**
     * Create an inline derived table from this table
     */
    @Override
    @PlainSQL
    public DebReleaseFile where(@Stringly.SQL String condition, QueryPart... parts) {
        return where(DSL.condition(condition, parts));
    }

    /**
     * Create an inline derived table from this table
     */
    @Override
    public DebReleaseFile whereExists(Select<?> select) {
        return where(DSL.exists(select));
    }

    /**
     * Create an inline derived table from this table
     */
    @Override
    public DebReleaseFile whereNotExists(Select<?> select) {
        return where(DSL.notExists(select));
    }
}
