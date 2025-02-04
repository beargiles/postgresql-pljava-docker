/*
 * This file is generated by jOOQ.
 */
package com.coyotesong.examples.pljava.persistence.jooq.generated;


import com.coyotesong.examples.pljava.persistence.jooq.generated.tables.DebBinary;
import com.coyotesong.examples.pljava.persistence.jooq.generated.tables.DebBinaryFile;
import com.coyotesong.examples.pljava.persistence.jooq.generated.tables.DebPackageInfo;
import com.coyotesong.examples.pljava.persistence.jooq.generated.tables.DebRelease;
import com.coyotesong.examples.pljava.persistence.jooq.generated.tables.DebReleaseFile;
import com.coyotesong.examples.pljava.persistence.jooq.generated.tables.DebSource;
import com.coyotesong.examples.pljava.persistence.jooq.generated.tables.DebSourceFile;
import com.coyotesong.examples.pljava.persistence.jooq.generated.tables.DebStatus;
import com.coyotesong.examples.pljava.persistence.jooq.generated.tables.FlywaySchemaHistory;

import java.util.Arrays;
import java.util.List;

import org.jooq.Catalog;
import org.jooq.Table;
import org.jooq.impl.SchemaImpl;


/**
 * This class is generated by jOOQ.
 */
@SuppressWarnings({ "all", "unchecked", "rawtypes", "this-escape" })
public class Public extends SchemaImpl {

    private static final long serialVersionUID = 1L;

    /**
     * The reference instance of <code>public</code>
     */
    public static final Public PUBLIC = new Public();

    /**
     * The table <code>public.deb_binary</code>.
     */
    public final DebBinary DEB_BINARY = DebBinary.DEB_BINARY;

    /**
     * The table <code>public.deb_binary_file</code>.
     */
    public final DebBinaryFile DEB_BINARY_FILE = DebBinaryFile.DEB_BINARY_FILE;

    /**
     * The table <code>public.deb_package_info</code>.
     */
    public final DebPackageInfo DEB_PACKAGE_INFO = DebPackageInfo.DEB_PACKAGE_INFO;

    /**
     * The table <code>public.deb_release</code>.
     */
    public final DebRelease DEB_RELEASE = DebRelease.DEB_RELEASE;

    /**
     * The table <code>public.deb_release_file</code>.
     */
    public final DebReleaseFile DEB_RELEASE_FILE = DebReleaseFile.DEB_RELEASE_FILE;

    /**
     * The table <code>public.deb_source</code>.
     */
    public final DebSource DEB_SOURCE = DebSource.DEB_SOURCE;

    /**
     * The table <code>public.deb_source_file</code>.
     */
    public final DebSourceFile DEB_SOURCE_FILE = DebSourceFile.DEB_SOURCE_FILE;

    /**
     * The table <code>public.deb_status</code>.
     */
    public final DebStatus DEB_STATUS = DebStatus.DEB_STATUS;

    /**
     * The table <code>public.flyway_schema_history</code>.
     */
    public final FlywaySchemaHistory FLYWAY_SCHEMA_HISTORY = FlywaySchemaHistory.FLYWAY_SCHEMA_HISTORY;

    /**
     * No further instances allowed
     */
    private Public() {
        super("public", null);
    }


    @Override
    public Catalog getCatalog() {
        return DefaultCatalog.DEFAULT_CATALOG;
    }

    @Override
    public final List<Table<?>> getTables() {
        return Arrays.asList(
            DebBinary.DEB_BINARY,
            DebBinaryFile.DEB_BINARY_FILE,
            DebPackageInfo.DEB_PACKAGE_INFO,
            DebRelease.DEB_RELEASE,
            DebReleaseFile.DEB_RELEASE_FILE,
            DebSource.DEB_SOURCE,
            DebSourceFile.DEB_SOURCE_FILE,
            DebStatus.DEB_STATUS,
            FlywaySchemaHistory.FLYWAY_SCHEMA_HISTORY
        );
    }
}
