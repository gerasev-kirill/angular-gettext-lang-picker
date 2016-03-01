module.exports = (grunt)->


	grunt.initConfig {
		pkg: grunt.file.readJSON('package.json'),
		replace: {
			options:{},
			files:{
				expand: true,
				cwd: 'dist',
				src: ['ui.gettext.lang.picker.js'],
				dest: 'dist'
			}
		},
		coffee:{
			compileJoined: {
				options:{
					join: true
				},
				files:{
					'dist/ui.gettext.lang.picker.js':['src/**/*.coffee']
				}
			}
		},
		uglify:{
			uiGLB:{
				files:{
					'dist/ui.gettext.lang.picker.min.js':['dist/ui.gettext.lang.picker.js']
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
					"dist/langPicker.html": "src/langPicker.jade"
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
				src: ['*.min.js'],
				dest: 'dist'
			}
		},
		ngAnnotate: {
			files:{
				cwd: 'dist',
				expand: true,
				src: ['ui.gettext.lang.picker.js'],
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
	grunt.registerTask 'dist-uglify', ['coffee:compileJoined', 'replace', 
									   'jade', 'ngAnnotate',
									   'uglify:uiGLB', 'angular_template_inline_js']
