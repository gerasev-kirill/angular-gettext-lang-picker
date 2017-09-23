module.exports = (grunt)->

	generateFilePattern = (dirs)->
		list=[]
		for d in dirs
			if '*' in d or d.indexOf('.js')>-1
				list.push(d)
				continue
			list.push("#{d}/**/module*.js")
			list.push("#{d}/**/!(module*)*.js")
		list

	grunt.initConfig {
		pkg: grunt.file.readJSON('package.json'),
		replace: {
			src:{
				options:{},
				files:[{
						expand: true,
						cwd: 'src',
						src: ['**/*.js', '**/*.html'],
						dest: 'src',
					}]
			}
		},
		coffee:{
			compile:{
				glob_to_multiple: {
					expand: true,
					cwd: 'src',
					src: ['**/*.coffee'],
					dest: 'src',
					ext: '.js'
				}
			}
		},
		concat:{
			dist:{
				src: generateFilePattern(['src']),
				dest: 'dist/ui.gettext.langPicker.js'
			}
		},
		uglify:{
			src:{
				files:{
					'dist/ui.gettext.langPicker.min.js': 'dist/ui.gettext.langPicker.js'
				}
			}
		},
		watch:{
			scripts:{
				files: ['src/**/*.js', 'src/**/*.html'],
				tasks: ['replace']
			}
		},
		jade: {
			compile: {
				glob_to_multiple: {
					expand: true,
					cwd: 'src',
					src: ['**/*.jade'],
					dest: 'src',
					ext: '.html'
				}
			}
		},
		angular_template_inline_js: {
			options:{
				basePath: __dirname
			},
			files:{
				cwd: 'src',
				expand: true,
				src: ['**/*.js'],
				dest: 'src'
			}
		},
		ngAnnotate: {
			files:{
				expand: true,
				cwd: 'src',
				src: ['**/*.js'],
				dest: 'src'
			}
		},
		ngdocs:
			options: {
				dest: 'doc',
				html5Mode: false,
				inlinePartials: true,
				title: 'LangPicker for gettext',
				startPage: '/api/ui.gettext.langPicker'
			},
			api: {
				src: ['src/**/*.js'],
				title: 'Angular API Reference'
			}
	}
	grunt.loadNpmTasks 'grunt-replace'
	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-simple-watch'
	grunt.loadNpmTasks 'grunt-contrib-jade'
	grunt.loadNpmTasks 'grunt-angular-template-inline-js'
	grunt.loadNpmTasks 'grunt-ng-annotate'
	grunt.loadNpmTasks 'grunt-contrib-concat'
	grunt.loadNpmTasks 'grunt-ngdocs'


	grunt.registerTask 'default', 'simple-watch'

	grunt.registerTask 'dist', [
			'coffee:compile',
			'replace:src',
			'jade:compile',
			'angular_template_inline_js',
			'ngAnnotate',
			'concat:dist',
			'uglify:src'
	]
