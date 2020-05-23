<?php
/**
 * Test the primary plugin file
 *
 * @package ChrisWiegman\WordPress_Plugin_Starter
 */

 namespace ChrisWiegman\WordPress_Plugin_Starter\Tests;

use function PHPUnit\Framework\assertEquals;
use function PHPUnit\Framework\assertTrue;

/**
 * Test the main plugin file
 */
class PluginFileTest extends \WP_Mock\Tools\TestCase {

	/**
	 * Test loader function
	 */
	public function test_chriswiegman_wordpress_plugin_starter_loader() {

		\WP_Mock::userFunction(
			'load_plugin_textdomain',
			array(
				'times' => 1,
			)
		);

		chriswiegman_wordpress_plugin_starter_loader();

		$this->assertConditionsMet();
		assertTrue( defined( 'CHRISWIEGMAN_WORDPRESS_PLUGIN_STARTER_VERSION' ) );

	}

	public function test_autoloader_registered() {
		$this->assertContains( 'chriswiegman_wordpress_plugin_starter_autoloader', spl_autoload_functions() );
	}

	public function test_autoloader() {

		$test_classes = array(
			'ChrisWiegman\WordPress_Plugin_Starter\Class_One' => '/app/plugin/lib/class-class-one.php',
			'ChrisWiegman\WordPress_Plugin_Starter\Sub_Classes\Class_Two' => '/app/plugin/lib/Sub_Classes/class-class-two.php',
			'Class_Three' => '',
		);

		foreach ( $test_classes as $test_class => $class_file ) {

			$file = chriswiegman_wordpress_plugin_starter_get_class_file( $test_class );

			assertEquals( $class_file, $file );

		}
	}
}
