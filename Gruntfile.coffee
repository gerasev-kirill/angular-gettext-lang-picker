module.exports = (grunt)->


	grunt.initConfig {
		pkg: grunt.file.readJSON('package.json'),
		replace: {
			options:{},
			files:{
				expand: true,
				cwd: 'dist',
				src: ['ui.gettext.langPicker.js'],
				dest: 'dist'
			}
		},
		coffee:{
			compileJoined: {
				options:{
					join: true
				},
				files:{
					'dist/ui.gettext.langPicker.js':['src/**/*.coffee']
				}
			}
		},
		uglify:{
			uiGLB:{
				files:{
					'dist/ui.gettext.langPicker.min.js':['dist/ui.gettext.langPicker.js']
				}
			}
		},
		watch:{
			scripts:{
				files: ['src/**/*.js', 'dist/**/*.js' ],
				tasks: ['replace']
			}
		},
		jade: {
			compile: {
				files: {
					"dist/langPicker.html": "src/langPicker.jade",
					"dist/langPickerForNavbar.html": "src/langPickerForNavbar.jade"
				}
			}
		},
		angular_template_inline_js: {
			options:{
				basePath: __dirname
			},
			files:{
				cwd: 'dist',
				expand: true,
				src: ['*.js'],
				dest: 'dist'
			}
		},
		ngAnnotate: {
			files:{
				cwd: 'dist',
				expand: true,
				src: ['ui.gettext.langPicker.js'],
				dest: 'dist'
			}
		}
	}
	grunt.loadNpmTasks 'grunt-replace'
	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-simple-watch'
	grunt.loadNpmTasks 'grunt-contrib-jade'
	grunt.loadNpmTasks 'grunt-angular-template-inline-js'
	grunt.loadNpmTasks 'grunt-ng-annotate'


	grunt.registerTask 'default', 'simple-watch'
	grunt.registerTask 'build', [
									'coffee:compileJoined', 'replace',
									'jade', 'ngAnnotate',
									'angular_template_inline_js', 'uglify:uiGLB'
								]
