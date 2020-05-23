<?php
/**
 * Plugin Name: WordPress Plugin Starter
 * Plugin URI: https://chriswiegman.com/
 * Description: Boilerplate code for starting a new WordPress plugin.
 * Version: 0.0.1
 * Text Domain: wordpress-plugin-starter
 * Domain Path: /languages
 * Author: Chris Wiegman
 * Author URI: https://chriswiegman.com/
 * License: GPLv2
 *
 * @package ChrisWiegman\WordPress_Plugin_Starter
 */

define( 'CHRISWIEGMAN_WORDPRESS_PLUGIN_STARTER_VERSION', '0.0.1' );

/**
 * Load plugin functionality.
 *
 * @since 1.0.0
 */
function chriswiegman_wordpress_plugin_starter_loader() {

	// Load the text domain.
	load_plugin_textdomain( 'wordpress-plugin-starter', false, dirname( dirname( __FILE__ ) ) . '/languages' );

}

/**
 * Builds the class file name for the plugin
 *
 * @since 1.0.0
 *
 * @param string $class The name of the class to get.
 * @return string
 */
function chriswiegman_wordpress_plugin_starter_get_class_file( $class ) {

	$prefix   = 'ChrisWiegman\\WordPress_Plugin_Starter\\';
	$base_dir = __DIR__ . '/lib/';

	$len = strlen( $prefix );

	if ( 0 !== strncmp( $prefix, $class, $len ) ) {
		return '';
	}

	$relative_class = substr( $class, $len );
	$file           = $base_dir . str_replace( '\\', '/', 'class-' . strtolower( str_replace( '_', '-', $relative_class ) ) ) . '.php';

	$relative_class_parts = explode( '\\', $relative_class );

	if ( 1 < count( $relative_class_parts ) ) {

		$class_file = $relative_class_parts[0] . '/class-' . strtolower( str_replace( '_', '-', $relative_class_parts[1] ) );
		$file       = $base_dir . str_replace( '\\', '/', $class_file ) . '.php';

	}

	return $file;

}

/**
 * Autoloading functionality for the plugin features
 *
 * @since 1.0.0
 *
 * @param object $class The class to load.
 */
function chriswiegman_wordpress_plugin_starter_autoloader( $class ) {

	$file = chriswiegman_wordpress_plugin_starter_get_class_file( $class );

	if ( ! empty( $file ) && file_exists( $file ) ) {
		include $file;
	}
}

spl_autoload_register( 'chriswiegman_wordpress_plugin_starter_autoloader' );

add_action( 'plugins_loaded', 'chriswiegman_wordpress_plugin_starter_loader' );
