
-if interface * { @retrofit2.http.* public *** *(...); }
-keep,allowoptimization,allowshrinking,allowobfuscation class <3>
#
#
## Keep interfaces parameters. Exceptions is to keep 'throws' clause in methods
#-keepattributes MethodParameters, Exceptions
#-keepparameternames