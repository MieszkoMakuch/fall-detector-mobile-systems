Øņ
Ż
9
Add
x"T
y"T
z"T"
Ttype:
2	
l
ArgMax

input"T
	dimension"Tidx

output	"
Ttype:
2	"
Tidxtype0:
2	
x
Assign
ref"T

value"T

output_ref"T"	
Ttype"
validate_shapebool("
use_lockingbool(
{
BiasAdd

value"T	
bias"T
output"T"
Ttype:
2	"-
data_formatstringNHWC:
NHWCNCHW
8
Cast	
x"SrcT	
y"DstT"
SrcTtype"
DstTtype
8
Const
output"dtype"
valuetensor"
dtypetype
A
Equal
x"T
y"T
z
"
Ttype:
2	

W

ExpandDims

input"T
dim"Tdim
output"T"	
Ttype"
Tdimtype0:
2	
S
HistogramSummary
tag
values"T
summary"
Ttype0:
2		
.
Identity

input"T
output"T"	
Ttype
o
MatMul
a"T
b"T
product"T"
transpose_abool( "
transpose_bbool( "
Ttype:

2

Mean

input"T
reduction_indices"Tidx
output"T"
	keep_dimsbool( "
Ttype:
2	"
Tidxtype0:
2	
b
MergeV2Checkpoints
checkpoint_prefixes
destination_prefix"
delete_old_dirsbool(
<
Mul
x"T
y"T
z"T"
Ttype:
2	

NoOp
M
Pack
values"T*N
output"T"
Nint(0"	
Ttype"
axisint 
ļ
ParseExample

serialized	
names
sparse_keys*Nsparse

dense_keys*Ndense
dense_defaults2Tdense
sparse_indices	*Nsparse
sparse_values2sparse_types
sparse_shapes	*Nsparse
dense_values2Tdense"
Nsparseint("
Ndenseint("%
sparse_types
list(type)(:
2	"
Tdense
list(type)(:
2	"
dense_shapeslist(shape)(
A
Placeholder
output"dtype"
dtypetype"
shapeshape: 
}
RandomUniform

shape"T
output"dtype"
seedint "
seed2int "
dtypetype:
2"
Ttype:
2	
`
Range
start"Tidx
limit"Tidx
delta"Tidx
output"Tidx"
Tidxtype0:
2	
A
Relu
features"T
activations"T"
Ttype:
2		
l
	RestoreV2

prefix
tensor_names
shape_and_slices
tensors2dtypes"
dtypes
list(type)(0
i
SaveV2

prefix
tensor_names
shape_and_slices
tensors2dtypes"
dtypes
list(type)(0
M
ScalarSummary
tags
values"T
summary"
Ttype:
2		
P
Shape

input"T
output"out_type"	
Ttype"
out_typetype0:
2	
H
ShardedFilename
basename	
shard

num_shards
filename
8
Softmax
logits"T
softmax"T"
Ttype:
2
ö
StridedSlice

input"T
begin"Index
end"Index
strides"Index
output"T"	
Ttype"
Indextype:
2	"

begin_maskint "
end_maskint "
ellipsis_maskint "
new_axis_maskint "
shrink_axis_maskint 
N

StringJoin
inputs*N

output"
Nint(0"
	separatorstring 
5
Sub
x"T
y"T
z"T"
Ttype:
	2	
c
Tile

input"T
	multiples"
Tmultiples
output"T"	
Ttype"

Tmultiplestype0:
2	
s

VariableV2
ref"dtype"
shapeshape"
dtypetype"
	containerstring "
shared_namestring "serve*1.1.02v1.1.0-rc0-61-g1ec6ed5ŗ

global_step/Initializer/ConstConst*
_output_shapes
: *
dtype0	*
_class
loc:@global_step*
value	B	 R 

global_step
VariableV2*
	container *
shared_name *
dtype0	*
shape: *
_output_shapes
: *
_class
loc:@global_step
²
global_step/AssignAssignglobal_stepglobal_step/Initializer/Const*
use_locking(*
T0	*
_class
loc:@global_step*
validate_shape(*
_output_shapes
: 
j
global_step/readIdentityglobal_step*
T0	*
_class
loc:@global_step*
_output_shapes
: 
b
input_example_tensorPlaceholder*#
_output_shapes
:’’’’’’’’’*
dtype0*
shape: 
U
ParseExample/ConstConst*
valueB *
dtype0*
_output_shapes
: 
b
ParseExample/ParseExample/namesConst*
dtype0*
_output_shapes
: *
valueB 
g
&ParseExample/ParseExample/dense_keys_0Const*
valueB B *
_output_shapes
: *
dtype0
”
ParseExample/ParseExampleParseExampleinput_example_tensorParseExample/ParseExample/names&ParseExample/ParseExample/dense_keys_0ParseExample/Const*
Nsparse *
sparse_types
 *
dense_shapes
:*
Tdense
2*
Ndense*'
_output_shapes
:’’’’’’’’’

Kdnn/input_from_feature_columns/input_from_feature_columns/concat/concat_dimConst*
dtype0*
_output_shapes
: *
value	B :

@dnn/input_from_feature_columns/input_from_feature_columns/concatIdentityParseExample/ParseExample*
T0*'
_output_shapes
:’’’’’’’’’
Ē
Adnn/hiddenlayer_0/weights/part_0/Initializer/random_uniform/shapeConst*3
_class)
'%loc:@dnn/hiddenlayer_0/weights/part_0*
valueB"   
   *
dtype0*
_output_shapes
:
¹
?dnn/hiddenlayer_0/weights/part_0/Initializer/random_uniform/minConst*
_output_shapes
: *
dtype0*3
_class)
'%loc:@dnn/hiddenlayer_0/weights/part_0*
valueB
 *b'æ
¹
?dnn/hiddenlayer_0/weights/part_0/Initializer/random_uniform/maxConst*
dtype0*
_output_shapes
: *3
_class)
'%loc:@dnn/hiddenlayer_0/weights/part_0*
valueB
 *b'?
”
Idnn/hiddenlayer_0/weights/part_0/Initializer/random_uniform/RandomUniformRandomUniformAdnn/hiddenlayer_0/weights/part_0/Initializer/random_uniform/shape*

seed *
T0*3
_class)
'%loc:@dnn/hiddenlayer_0/weights/part_0*
seed2 *
dtype0*
_output_shapes

:


?dnn/hiddenlayer_0/weights/part_0/Initializer/random_uniform/subSub?dnn/hiddenlayer_0/weights/part_0/Initializer/random_uniform/max?dnn/hiddenlayer_0/weights/part_0/Initializer/random_uniform/min*3
_class)
'%loc:@dnn/hiddenlayer_0/weights/part_0*
_output_shapes
: *
T0
°
?dnn/hiddenlayer_0/weights/part_0/Initializer/random_uniform/mulMulIdnn/hiddenlayer_0/weights/part_0/Initializer/random_uniform/RandomUniform?dnn/hiddenlayer_0/weights/part_0/Initializer/random_uniform/sub*
T0*3
_class)
'%loc:@dnn/hiddenlayer_0/weights/part_0*
_output_shapes

:

¢
;dnn/hiddenlayer_0/weights/part_0/Initializer/random_uniformAdd?dnn/hiddenlayer_0/weights/part_0/Initializer/random_uniform/mul?dnn/hiddenlayer_0/weights/part_0/Initializer/random_uniform/min*
T0*3
_class)
'%loc:@dnn/hiddenlayer_0/weights/part_0*
_output_shapes

:

É
 dnn/hiddenlayer_0/weights/part_0
VariableV2*3
_class)
'%loc:@dnn/hiddenlayer_0/weights/part_0*
_output_shapes

:
*
shape
:
*
dtype0*
shared_name *
	container 

'dnn/hiddenlayer_0/weights/part_0/AssignAssign dnn/hiddenlayer_0/weights/part_0;dnn/hiddenlayer_0/weights/part_0/Initializer/random_uniform*3
_class)
'%loc:@dnn/hiddenlayer_0/weights/part_0*
_output_shapes

:
*
T0*
validate_shape(*
use_locking(
±
%dnn/hiddenlayer_0/weights/part_0/readIdentity dnn/hiddenlayer_0/weights/part_0*
T0*
_output_shapes

:
*3
_class)
'%loc:@dnn/hiddenlayer_0/weights/part_0
²
1dnn/hiddenlayer_0/biases/part_0/Initializer/ConstConst*
_output_shapes
:
*
dtype0*2
_class(
&$loc:@dnn/hiddenlayer_0/biases/part_0*
valueB
*    
æ
dnn/hiddenlayer_0/biases/part_0
VariableV2*
shared_name *2
_class(
&$loc:@dnn/hiddenlayer_0/biases/part_0*
	container *
shape:
*
dtype0*
_output_shapes
:


&dnn/hiddenlayer_0/biases/part_0/AssignAssigndnn/hiddenlayer_0/biases/part_01dnn/hiddenlayer_0/biases/part_0/Initializer/Const*
use_locking(*
validate_shape(*
T0*
_output_shapes
:
*2
_class(
&$loc:@dnn/hiddenlayer_0/biases/part_0
Ŗ
$dnn/hiddenlayer_0/biases/part_0/readIdentitydnn/hiddenlayer_0/biases/part_0*2
_class(
&$loc:@dnn/hiddenlayer_0/biases/part_0*
_output_shapes
:
*
T0
u
dnn/hiddenlayer_0/weightsIdentity%dnn/hiddenlayer_0/weights/part_0/read*
_output_shapes

:
*
T0
×
dnn/hiddenlayer_0/MatMulMatMul@dnn/input_from_feature_columns/input_from_feature_columns/concatdnn/hiddenlayer_0/weights*
transpose_b( *
T0*'
_output_shapes
:’’’’’’’’’
*
transpose_a( 
o
dnn/hiddenlayer_0/biasesIdentity$dnn/hiddenlayer_0/biases/part_0/read*
_output_shapes
:
*
T0
”
dnn/hiddenlayer_0/BiasAddBiasAdddnn/hiddenlayer_0/MatMuldnn/hiddenlayer_0/biases*
data_formatNHWC*
T0*'
_output_shapes
:’’’’’’’’’

y
$dnn/hiddenlayer_0/hiddenlayer_0/ReluReludnn/hiddenlayer_0/BiasAdd*
T0*'
_output_shapes
:’’’’’’’’’

[
dnn/zero_fraction/zeroConst*
dtype0*
_output_shapes
: *
valueB
 *    

dnn/zero_fraction/EqualEqual$dnn/hiddenlayer_0/hiddenlayer_0/Reludnn/zero_fraction/zero*
T0*'
_output_shapes
:’’’’’’’’’

x
dnn/zero_fraction/CastCastdnn/zero_fraction/Equal*

SrcT0
*'
_output_shapes
:’’’’’’’’’
*

DstT0
h
dnn/zero_fraction/ConstConst*
_output_shapes
:*
dtype0*
valueB"       

dnn/zero_fraction/MeanMeandnn/zero_fraction/Castdnn/zero_fraction/Const*
_output_shapes
: *
T0*

Tidx0*
	keep_dims( 
 
2dnn/dnn/hiddenlayer_0_fraction_of_zero_values/tagsConst*>
value5B3 B-dnn/dnn/hiddenlayer_0_fraction_of_zero_values*
_output_shapes
: *
dtype0
«
-dnn/dnn/hiddenlayer_0_fraction_of_zero_valuesScalarSummary2dnn/dnn/hiddenlayer_0_fraction_of_zero_values/tagsdnn/zero_fraction/Mean*
_output_shapes
: *
T0

$dnn/dnn/hiddenlayer_0_activation/tagConst*1
value(B& B dnn/dnn/hiddenlayer_0_activation*
_output_shapes
: *
dtype0
”
 dnn/dnn/hiddenlayer_0_activationHistogramSummary$dnn/dnn/hiddenlayer_0_activation/tag$dnn/hiddenlayer_0/hiddenlayer_0/Relu*
_output_shapes
: *
T0
Ē
Adnn/hiddenlayer_1/weights/part_0/Initializer/random_uniform/shapeConst*3
_class)
'%loc:@dnn/hiddenlayer_1/weights/part_0*
valueB"
      *
_output_shapes
:*
dtype0
¹
?dnn/hiddenlayer_1/weights/part_0/Initializer/random_uniform/minConst*3
_class)
'%loc:@dnn/hiddenlayer_1/weights/part_0*
valueB
 *.łä¾*
dtype0*
_output_shapes
: 
¹
?dnn/hiddenlayer_1/weights/part_0/Initializer/random_uniform/maxConst*
dtype0*
_output_shapes
: *3
_class)
'%loc:@dnn/hiddenlayer_1/weights/part_0*
valueB
 *.łä>
”
Idnn/hiddenlayer_1/weights/part_0/Initializer/random_uniform/RandomUniformRandomUniformAdnn/hiddenlayer_1/weights/part_0/Initializer/random_uniform/shape*
T0*
_output_shapes

:
*

seed *3
_class)
'%loc:@dnn/hiddenlayer_1/weights/part_0*
dtype0*
seed2 

?dnn/hiddenlayer_1/weights/part_0/Initializer/random_uniform/subSub?dnn/hiddenlayer_1/weights/part_0/Initializer/random_uniform/max?dnn/hiddenlayer_1/weights/part_0/Initializer/random_uniform/min*
T0*3
_class)
'%loc:@dnn/hiddenlayer_1/weights/part_0*
_output_shapes
: 
°
?dnn/hiddenlayer_1/weights/part_0/Initializer/random_uniform/mulMulIdnn/hiddenlayer_1/weights/part_0/Initializer/random_uniform/RandomUniform?dnn/hiddenlayer_1/weights/part_0/Initializer/random_uniform/sub*
T0*
_output_shapes

:
*3
_class)
'%loc:@dnn/hiddenlayer_1/weights/part_0
¢
;dnn/hiddenlayer_1/weights/part_0/Initializer/random_uniformAdd?dnn/hiddenlayer_1/weights/part_0/Initializer/random_uniform/mul?dnn/hiddenlayer_1/weights/part_0/Initializer/random_uniform/min*
_output_shapes

:
*3
_class)
'%loc:@dnn/hiddenlayer_1/weights/part_0*
T0
É
 dnn/hiddenlayer_1/weights/part_0
VariableV2*
	container *
dtype0*3
_class)
'%loc:@dnn/hiddenlayer_1/weights/part_0*
_output_shapes

:
*
shape
:
*
shared_name 

'dnn/hiddenlayer_1/weights/part_0/AssignAssign dnn/hiddenlayer_1/weights/part_0;dnn/hiddenlayer_1/weights/part_0/Initializer/random_uniform*
use_locking(*
validate_shape(*
T0*
_output_shapes

:
*3
_class)
'%loc:@dnn/hiddenlayer_1/weights/part_0
±
%dnn/hiddenlayer_1/weights/part_0/readIdentity dnn/hiddenlayer_1/weights/part_0*
T0*
_output_shapes

:
*3
_class)
'%loc:@dnn/hiddenlayer_1/weights/part_0
²
1dnn/hiddenlayer_1/biases/part_0/Initializer/ConstConst*
_output_shapes
:*
dtype0*2
_class(
&$loc:@dnn/hiddenlayer_1/biases/part_0*
valueB*    
æ
dnn/hiddenlayer_1/biases/part_0
VariableV2*
shared_name *
shape:*
_output_shapes
:*2
_class(
&$loc:@dnn/hiddenlayer_1/biases/part_0*
dtype0*
	container 

&dnn/hiddenlayer_1/biases/part_0/AssignAssigndnn/hiddenlayer_1/biases/part_01dnn/hiddenlayer_1/biases/part_0/Initializer/Const*
_output_shapes
:*
validate_shape(*2
_class(
&$loc:@dnn/hiddenlayer_1/biases/part_0*
T0*
use_locking(
Ŗ
$dnn/hiddenlayer_1/biases/part_0/readIdentitydnn/hiddenlayer_1/biases/part_0*2
_class(
&$loc:@dnn/hiddenlayer_1/biases/part_0*
_output_shapes
:*
T0
u
dnn/hiddenlayer_1/weightsIdentity%dnn/hiddenlayer_1/weights/part_0/read*
T0*
_output_shapes

:

»
dnn/hiddenlayer_1/MatMulMatMul$dnn/hiddenlayer_0/hiddenlayer_0/Reludnn/hiddenlayer_1/weights*
transpose_b( *'
_output_shapes
:’’’’’’’’’*
transpose_a( *
T0
o
dnn/hiddenlayer_1/biasesIdentity$dnn/hiddenlayer_1/biases/part_0/read*
T0*
_output_shapes
:
”
dnn/hiddenlayer_1/BiasAddBiasAdddnn/hiddenlayer_1/MatMuldnn/hiddenlayer_1/biases*
T0*
data_formatNHWC*'
_output_shapes
:’’’’’’’’’
y
$dnn/hiddenlayer_1/hiddenlayer_1/ReluReludnn/hiddenlayer_1/BiasAdd*'
_output_shapes
:’’’’’’’’’*
T0
]
dnn/zero_fraction_1/zeroConst*
valueB
 *    *
dtype0*
_output_shapes
: 

dnn/zero_fraction_1/EqualEqual$dnn/hiddenlayer_1/hiddenlayer_1/Reludnn/zero_fraction_1/zero*
T0*'
_output_shapes
:’’’’’’’’’
|
dnn/zero_fraction_1/CastCastdnn/zero_fraction_1/Equal*'
_output_shapes
:’’’’’’’’’*

DstT0*

SrcT0

j
dnn/zero_fraction_1/ConstConst*
valueB"       *
_output_shapes
:*
dtype0

dnn/zero_fraction_1/MeanMeandnn/zero_fraction_1/Castdnn/zero_fraction_1/Const*
_output_shapes
: *
T0*

Tidx0*
	keep_dims( 
 
2dnn/dnn/hiddenlayer_1_fraction_of_zero_values/tagsConst*
dtype0*
_output_shapes
: *>
value5B3 B-dnn/dnn/hiddenlayer_1_fraction_of_zero_values
­
-dnn/dnn/hiddenlayer_1_fraction_of_zero_valuesScalarSummary2dnn/dnn/hiddenlayer_1_fraction_of_zero_values/tagsdnn/zero_fraction_1/Mean*
T0*
_output_shapes
: 

$dnn/dnn/hiddenlayer_1_activation/tagConst*1
value(B& B dnn/dnn/hiddenlayer_1_activation*
dtype0*
_output_shapes
: 
”
 dnn/dnn/hiddenlayer_1_activationHistogramSummary$dnn/dnn/hiddenlayer_1_activation/tag$dnn/hiddenlayer_1/hiddenlayer_1/Relu*
_output_shapes
: *
T0
Ē
Adnn/hiddenlayer_2/weights/part_0/Initializer/random_uniform/shapeConst*
_output_shapes
:*
dtype0*3
_class)
'%loc:@dnn/hiddenlayer_2/weights/part_0*
valueB"   
   
¹
?dnn/hiddenlayer_2/weights/part_0/Initializer/random_uniform/minConst*
dtype0*
_output_shapes
: *3
_class)
'%loc:@dnn/hiddenlayer_2/weights/part_0*
valueB
 *.łä¾
¹
?dnn/hiddenlayer_2/weights/part_0/Initializer/random_uniform/maxConst*3
_class)
'%loc:@dnn/hiddenlayer_2/weights/part_0*
valueB
 *.łä>*
dtype0*
_output_shapes
: 
”
Idnn/hiddenlayer_2/weights/part_0/Initializer/random_uniform/RandomUniformRandomUniformAdnn/hiddenlayer_2/weights/part_0/Initializer/random_uniform/shape*

seed *
T0*3
_class)
'%loc:@dnn/hiddenlayer_2/weights/part_0*
seed2 *
dtype0*
_output_shapes

:


?dnn/hiddenlayer_2/weights/part_0/Initializer/random_uniform/subSub?dnn/hiddenlayer_2/weights/part_0/Initializer/random_uniform/max?dnn/hiddenlayer_2/weights/part_0/Initializer/random_uniform/min*3
_class)
'%loc:@dnn/hiddenlayer_2/weights/part_0*
_output_shapes
: *
T0
°
?dnn/hiddenlayer_2/weights/part_0/Initializer/random_uniform/mulMulIdnn/hiddenlayer_2/weights/part_0/Initializer/random_uniform/RandomUniform?dnn/hiddenlayer_2/weights/part_0/Initializer/random_uniform/sub*
T0*3
_class)
'%loc:@dnn/hiddenlayer_2/weights/part_0*
_output_shapes

:

¢
;dnn/hiddenlayer_2/weights/part_0/Initializer/random_uniformAdd?dnn/hiddenlayer_2/weights/part_0/Initializer/random_uniform/mul?dnn/hiddenlayer_2/weights/part_0/Initializer/random_uniform/min*
_output_shapes

:
*3
_class)
'%loc:@dnn/hiddenlayer_2/weights/part_0*
T0
É
 dnn/hiddenlayer_2/weights/part_0
VariableV2*
shared_name *3
_class)
'%loc:@dnn/hiddenlayer_2/weights/part_0*
	container *
shape
:
*
dtype0*
_output_shapes

:


'dnn/hiddenlayer_2/weights/part_0/AssignAssign dnn/hiddenlayer_2/weights/part_0;dnn/hiddenlayer_2/weights/part_0/Initializer/random_uniform*
use_locking(*
T0*3
_class)
'%loc:@dnn/hiddenlayer_2/weights/part_0*
validate_shape(*
_output_shapes

:

±
%dnn/hiddenlayer_2/weights/part_0/readIdentity dnn/hiddenlayer_2/weights/part_0*
T0*3
_class)
'%loc:@dnn/hiddenlayer_2/weights/part_0*
_output_shapes

:

²
1dnn/hiddenlayer_2/biases/part_0/Initializer/ConstConst*
_output_shapes
:
*
dtype0*2
_class(
&$loc:@dnn/hiddenlayer_2/biases/part_0*
valueB
*    
æ
dnn/hiddenlayer_2/biases/part_0
VariableV2*
shared_name *2
_class(
&$loc:@dnn/hiddenlayer_2/biases/part_0*
	container *
shape:
*
dtype0*
_output_shapes
:


&dnn/hiddenlayer_2/biases/part_0/AssignAssigndnn/hiddenlayer_2/biases/part_01dnn/hiddenlayer_2/biases/part_0/Initializer/Const*2
_class(
&$loc:@dnn/hiddenlayer_2/biases/part_0*
_output_shapes
:
*
T0*
validate_shape(*
use_locking(
Ŗ
$dnn/hiddenlayer_2/biases/part_0/readIdentitydnn/hiddenlayer_2/biases/part_0*2
_class(
&$loc:@dnn/hiddenlayer_2/biases/part_0*
_output_shapes
:
*
T0
u
dnn/hiddenlayer_2/weightsIdentity%dnn/hiddenlayer_2/weights/part_0/read*
T0*
_output_shapes

:

»
dnn/hiddenlayer_2/MatMulMatMul$dnn/hiddenlayer_1/hiddenlayer_1/Reludnn/hiddenlayer_2/weights*
transpose_b( *
T0*'
_output_shapes
:’’’’’’’’’
*
transpose_a( 
o
dnn/hiddenlayer_2/biasesIdentity$dnn/hiddenlayer_2/biases/part_0/read*
_output_shapes
:
*
T0
”
dnn/hiddenlayer_2/BiasAddBiasAdddnn/hiddenlayer_2/MatMuldnn/hiddenlayer_2/biases*'
_output_shapes
:’’’’’’’’’
*
data_formatNHWC*
T0
y
$dnn/hiddenlayer_2/hiddenlayer_2/ReluReludnn/hiddenlayer_2/BiasAdd*
T0*'
_output_shapes
:’’’’’’’’’

]
dnn/zero_fraction_2/zeroConst*
valueB
 *    *
_output_shapes
: *
dtype0

dnn/zero_fraction_2/EqualEqual$dnn/hiddenlayer_2/hiddenlayer_2/Reludnn/zero_fraction_2/zero*
T0*'
_output_shapes
:’’’’’’’’’

|
dnn/zero_fraction_2/CastCastdnn/zero_fraction_2/Equal*

SrcT0
*'
_output_shapes
:’’’’’’’’’
*

DstT0
j
dnn/zero_fraction_2/ConstConst*
valueB"       *
_output_shapes
:*
dtype0

dnn/zero_fraction_2/MeanMeandnn/zero_fraction_2/Castdnn/zero_fraction_2/Const*
_output_shapes
: *
T0*

Tidx0*
	keep_dims( 
 
2dnn/dnn/hiddenlayer_2_fraction_of_zero_values/tagsConst*>
value5B3 B-dnn/dnn/hiddenlayer_2_fraction_of_zero_values*
dtype0*
_output_shapes
: 
­
-dnn/dnn/hiddenlayer_2_fraction_of_zero_valuesScalarSummary2dnn/dnn/hiddenlayer_2_fraction_of_zero_values/tagsdnn/zero_fraction_2/Mean*
_output_shapes
: *
T0

$dnn/dnn/hiddenlayer_2_activation/tagConst*1
value(B& B dnn/dnn/hiddenlayer_2_activation*
dtype0*
_output_shapes
: 
”
 dnn/dnn/hiddenlayer_2_activationHistogramSummary$dnn/dnn/hiddenlayer_2_activation/tag$dnn/hiddenlayer_2/hiddenlayer_2/Relu*
T0*
_output_shapes
: 
¹
:dnn/logits/weights/part_0/Initializer/random_uniform/shapeConst*
dtype0*
_output_shapes
:*,
_class"
 loc:@dnn/logits/weights/part_0*
valueB"
      
«
8dnn/logits/weights/part_0/Initializer/random_uniform/minConst*
dtype0*
_output_shapes
: *,
_class"
 loc:@dnn/logits/weights/part_0*
valueB
 *b'æ
«
8dnn/logits/weights/part_0/Initializer/random_uniform/maxConst*
dtype0*
_output_shapes
: *,
_class"
 loc:@dnn/logits/weights/part_0*
valueB
 *b'?

Bdnn/logits/weights/part_0/Initializer/random_uniform/RandomUniformRandomUniform:dnn/logits/weights/part_0/Initializer/random_uniform/shape*
T0*
_output_shapes

:
*

seed *,
_class"
 loc:@dnn/logits/weights/part_0*
dtype0*
seed2 

8dnn/logits/weights/part_0/Initializer/random_uniform/subSub8dnn/logits/weights/part_0/Initializer/random_uniform/max8dnn/logits/weights/part_0/Initializer/random_uniform/min*
T0*,
_class"
 loc:@dnn/logits/weights/part_0*
_output_shapes
: 

8dnn/logits/weights/part_0/Initializer/random_uniform/mulMulBdnn/logits/weights/part_0/Initializer/random_uniform/RandomUniform8dnn/logits/weights/part_0/Initializer/random_uniform/sub*
_output_shapes

:
*,
_class"
 loc:@dnn/logits/weights/part_0*
T0

4dnn/logits/weights/part_0/Initializer/random_uniformAdd8dnn/logits/weights/part_0/Initializer/random_uniform/mul8dnn/logits/weights/part_0/Initializer/random_uniform/min*,
_class"
 loc:@dnn/logits/weights/part_0*
_output_shapes

:
*
T0
»
dnn/logits/weights/part_0
VariableV2*
shape
:
*
_output_shapes

:
*
shared_name *,
_class"
 loc:@dnn/logits/weights/part_0*
dtype0*
	container 
ū
 dnn/logits/weights/part_0/AssignAssigndnn/logits/weights/part_04dnn/logits/weights/part_0/Initializer/random_uniform*
use_locking(*
T0*,
_class"
 loc:@dnn/logits/weights/part_0*
validate_shape(*
_output_shapes

:


dnn/logits/weights/part_0/readIdentitydnn/logits/weights/part_0*,
_class"
 loc:@dnn/logits/weights/part_0*
_output_shapes

:
*
T0
¤
*dnn/logits/biases/part_0/Initializer/ConstConst*
_output_shapes
:*
dtype0*+
_class!
loc:@dnn/logits/biases/part_0*
valueB*    
±
dnn/logits/biases/part_0
VariableV2*
	container *
shared_name *
dtype0*
shape:*
_output_shapes
:*+
_class!
loc:@dnn/logits/biases/part_0
ź
dnn/logits/biases/part_0/AssignAssigndnn/logits/biases/part_0*dnn/logits/biases/part_0/Initializer/Const*+
_class!
loc:@dnn/logits/biases/part_0*
_output_shapes
:*
T0*
validate_shape(*
use_locking(

dnn/logits/biases/part_0/readIdentitydnn/logits/biases/part_0*+
_class!
loc:@dnn/logits/biases/part_0*
_output_shapes
:*
T0
g
dnn/logits/weightsIdentitydnn/logits/weights/part_0/read*
T0*
_output_shapes

:

­
dnn/logits/MatMulMatMul$dnn/hiddenlayer_2/hiddenlayer_2/Reludnn/logits/weights*
transpose_b( *'
_output_shapes
:’’’’’’’’’*
transpose_a( *
T0
a
dnn/logits/biasesIdentitydnn/logits/biases/part_0/read*
_output_shapes
:*
T0

dnn/logits/BiasAddBiasAdddnn/logits/MatMuldnn/logits/biases*
T0*
data_formatNHWC*'
_output_shapes
:’’’’’’’’’
]
dnn/zero_fraction_3/zeroConst*
valueB
 *    *
_output_shapes
: *
dtype0

dnn/zero_fraction_3/EqualEqualdnn/logits/BiasAdddnn/zero_fraction_3/zero*
T0*'
_output_shapes
:’’’’’’’’’
|
dnn/zero_fraction_3/CastCastdnn/zero_fraction_3/Equal*'
_output_shapes
:’’’’’’’’’*

DstT0*

SrcT0

j
dnn/zero_fraction_3/ConstConst*
valueB"       *
_output_shapes
:*
dtype0

dnn/zero_fraction_3/MeanMeandnn/zero_fraction_3/Castdnn/zero_fraction_3/Const*
_output_shapes
: *
T0*

Tidx0*
	keep_dims( 

+dnn/dnn/logits_fraction_of_zero_values/tagsConst*7
value.B, B&dnn/dnn/logits_fraction_of_zero_values*
dtype0*
_output_shapes
: 

&dnn/dnn/logits_fraction_of_zero_valuesScalarSummary+dnn/dnn/logits_fraction_of_zero_values/tagsdnn/zero_fraction_3/Mean*
_output_shapes
: *
T0
w
dnn/dnn/logits_activation/tagConst*
dtype0*
_output_shapes
: **
value!B Bdnn/dnn/logits_activation

dnn/dnn/logits_activationHistogramSummarydnn/dnn/logits_activation/tagdnn/logits/BiasAdd*
T0*
_output_shapes
: 
t
2dnn/multi_class_head/predictions/classes/dimensionConst*
value	B :*
_output_shapes
: *
dtype0
“
(dnn/multi_class_head/predictions/classesArgMaxdnn/logits/BiasAdd2dnn/multi_class_head/predictions/classes/dimension*

Tidx0*
T0*#
_output_shapes
:’’’’’’’’’

.dnn/multi_class_head/predictions/probabilitiesSoftmaxdnn/logits/BiasAdd*
T0*'
_output_shapes
:’’’’’’’’’

dnn/multi_class_head/ShapeShape.dnn/multi_class_head/predictions/probabilities*
T0*
_output_shapes
:*
out_type0
r
(dnn/multi_class_head/strided_slice/stackConst*
valueB: *
dtype0*
_output_shapes
:
t
*dnn/multi_class_head/strided_slice/stack_1Const*
dtype0*
_output_shapes
:*
valueB:
t
*dnn/multi_class_head/strided_slice/stack_2Const*
_output_shapes
:*
dtype0*
valueB:
ā
"dnn/multi_class_head/strided_sliceStridedSlicednn/multi_class_head/Shape(dnn/multi_class_head/strided_slice/stack*dnn/multi_class_head/strided_slice/stack_1*dnn/multi_class_head/strided_slice/stack_2*
_output_shapes
: *
end_mask *
new_axis_mask *
ellipsis_mask *

begin_mask *
shrink_axis_mask*
Index0*
T0
b
 dnn/multi_class_head/range/startConst*
value	B : *
dtype0*
_output_shapes
: 
b
 dnn/multi_class_head/range/limitConst*
value	B :*
_output_shapes
: *
dtype0
b
 dnn/multi_class_head/range/deltaConst*
value	B :*
dtype0*
_output_shapes
: 
±
dnn/multi_class_head/rangeRange dnn/multi_class_head/range/start dnn/multi_class_head/range/limit dnn/multi_class_head/range/delta*

Tidx0*
_output_shapes
:
e
#dnn/multi_class_head/ExpandDims/dimConst*
dtype0*
_output_shapes
: *
value	B : 
£
dnn/multi_class_head/ExpandDims
ExpandDimsdnn/multi_class_head/range#dnn/multi_class_head/ExpandDims/dim*

Tdim0*
T0*
_output_shapes

:
g
%dnn/multi_class_head/Tile/multiples/1Const*
value	B :*
_output_shapes
: *
dtype0
°
#dnn/multi_class_head/Tile/multiplesPack"dnn/multi_class_head/strided_slice%dnn/multi_class_head/Tile/multiples/1*

axis *
_output_shapes
:*
T0*
N
«
dnn/multi_class_head/TileTilednn/multi_class_head/ExpandDims#dnn/multi_class_head/Tile/multiples*'
_output_shapes
:’’’’’’’’’*
T0*

Tmultiples0

initNoOp

init_all_tablesNoOp

init_1NoOp
P

save/ConstConst*
valueB Bmodel*
dtype0*
_output_shapes
: 

save/StringJoin/inputs_1Const*
_output_shapes
: *
dtype0*<
value3B1 B+_temp_146a50d142074487abc770ef0e394729/part
u
save/StringJoin
StringJoin
save/Constsave/StringJoin/inputs_1*
_output_shapes
: *
N*
	separator 
Q
save/num_shardsConst*
dtype0*
_output_shapes
: *
value	B :
\
save/ShardedFilename/shardConst*
dtype0*
_output_shapes
: *
value	B : 
}
save/ShardedFilenameShardedFilenamesave/StringJoinsave/ShardedFilename/shardsave/num_shards*
_output_shapes
: 
µ
save/SaveV2/tensor_namesConst*č
valueŽBŪ	Bdnn/hiddenlayer_0/biasesBdnn/hiddenlayer_0/weightsBdnn/hiddenlayer_1/biasesBdnn/hiddenlayer_1/weightsBdnn/hiddenlayer_2/biasesBdnn/hiddenlayer_2/weightsBdnn/logits/biasesBdnn/logits/weightsBglobal_step*
dtype0*
_output_shapes
:	
Ē
save/SaveV2/shape_and_slicesConst*w
valuenBl	B10 0,10B4 10 0,4:0,10B20 0,20B10 20 0,10:0,20B10 0,10B20 10 0,20:0,10B4 0,4B10 4 0,10:0,4B *
dtype0*
_output_shapes
:	
Æ
save/SaveV2SaveV2save/ShardedFilenamesave/SaveV2/tensor_namessave/SaveV2/shape_and_slices$dnn/hiddenlayer_0/biases/part_0/read%dnn/hiddenlayer_0/weights/part_0/read$dnn/hiddenlayer_1/biases/part_0/read%dnn/hiddenlayer_1/weights/part_0/read$dnn/hiddenlayer_2/biases/part_0/read%dnn/hiddenlayer_2/weights/part_0/readdnn/logits/biases/part_0/readdnn/logits/weights/part_0/readglobal_step*
dtypes
2		

save/control_dependencyIdentitysave/ShardedFilename^save/SaveV2*
_output_shapes
: *'
_class
loc:@save/ShardedFilename*
T0

+save/MergeV2Checkpoints/checkpoint_prefixesPacksave/ShardedFilename^save/control_dependency*
_output_shapes
:*
N*

axis *
T0
}
save/MergeV2CheckpointsMergeV2Checkpoints+save/MergeV2Checkpoints/checkpoint_prefixes
save/Const*
delete_old_dirs(
z
save/IdentityIdentity
save/Const^save/control_dependency^save/MergeV2Checkpoints*
T0*
_output_shapes
: 
|
save/RestoreV2/tensor_namesConst*
_output_shapes
:*
dtype0*-
value$B"Bdnn/hiddenlayer_0/biases
o
save/RestoreV2/shape_and_slicesConst*
valueBB10 0,10*
dtype0*
_output_shapes
:

save/RestoreV2	RestoreV2
save/Constsave/RestoreV2/tensor_namessave/RestoreV2/shape_and_slices*
dtypes
2*
_output_shapes
:
Č
save/AssignAssigndnn/hiddenlayer_0/biases/part_0save/RestoreV2*
use_locking(*
validate_shape(*
T0*
_output_shapes
:
*2
_class(
&$loc:@dnn/hiddenlayer_0/biases/part_0

save/RestoreV2_1/tensor_namesConst*.
value%B#Bdnn/hiddenlayer_0/weights*
dtype0*
_output_shapes
:
w
!save/RestoreV2_1/shape_and_slicesConst*"
valueBB4 10 0,4:0,10*
_output_shapes
:*
dtype0

save/RestoreV2_1	RestoreV2
save/Constsave/RestoreV2_1/tensor_names!save/RestoreV2_1/shape_and_slices*
dtypes
2*
_output_shapes
:
Ņ
save/Assign_1Assign dnn/hiddenlayer_0/weights/part_0save/RestoreV2_1*
use_locking(*
validate_shape(*
T0*
_output_shapes

:
*3
_class)
'%loc:@dnn/hiddenlayer_0/weights/part_0
~
save/RestoreV2_2/tensor_namesConst*-
value$B"Bdnn/hiddenlayer_1/biases*
_output_shapes
:*
dtype0
q
!save/RestoreV2_2/shape_and_slicesConst*
valueBB20 0,20*
dtype0*
_output_shapes
:

save/RestoreV2_2	RestoreV2
save/Constsave/RestoreV2_2/tensor_names!save/RestoreV2_2/shape_and_slices*
_output_shapes
:*
dtypes
2
Ģ
save/Assign_2Assigndnn/hiddenlayer_1/biases/part_0save/RestoreV2_2*
use_locking(*
T0*2
_class(
&$loc:@dnn/hiddenlayer_1/biases/part_0*
validate_shape(*
_output_shapes
:

save/RestoreV2_3/tensor_namesConst*.
value%B#Bdnn/hiddenlayer_1/weights*
_output_shapes
:*
dtype0
y
!save/RestoreV2_3/shape_and_slicesConst*$
valueBB10 20 0,10:0,20*
dtype0*
_output_shapes
:

save/RestoreV2_3	RestoreV2
save/Constsave/RestoreV2_3/tensor_names!save/RestoreV2_3/shape_and_slices*
_output_shapes
:*
dtypes
2
Ņ
save/Assign_3Assign dnn/hiddenlayer_1/weights/part_0save/RestoreV2_3*3
_class)
'%loc:@dnn/hiddenlayer_1/weights/part_0*
_output_shapes

:
*
T0*
validate_shape(*
use_locking(
~
save/RestoreV2_4/tensor_namesConst*-
value$B"Bdnn/hiddenlayer_2/biases*
_output_shapes
:*
dtype0
q
!save/RestoreV2_4/shape_and_slicesConst*
valueBB10 0,10*
dtype0*
_output_shapes
:

save/RestoreV2_4	RestoreV2
save/Constsave/RestoreV2_4/tensor_names!save/RestoreV2_4/shape_and_slices*
dtypes
2*
_output_shapes
:
Ģ
save/Assign_4Assigndnn/hiddenlayer_2/biases/part_0save/RestoreV2_4*
_output_shapes
:
*
validate_shape(*2
_class(
&$loc:@dnn/hiddenlayer_2/biases/part_0*
T0*
use_locking(

save/RestoreV2_5/tensor_namesConst*
_output_shapes
:*
dtype0*.
value%B#Bdnn/hiddenlayer_2/weights
y
!save/RestoreV2_5/shape_and_slicesConst*$
valueBB20 10 0,20:0,10*
dtype0*
_output_shapes
:

save/RestoreV2_5	RestoreV2
save/Constsave/RestoreV2_5/tensor_names!save/RestoreV2_5/shape_and_slices*
dtypes
2*
_output_shapes
:
Ņ
save/Assign_5Assign dnn/hiddenlayer_2/weights/part_0save/RestoreV2_5*3
_class)
'%loc:@dnn/hiddenlayer_2/weights/part_0*
_output_shapes

:
*
T0*
validate_shape(*
use_locking(
w
save/RestoreV2_6/tensor_namesConst*&
valueBBdnn/logits/biases*
_output_shapes
:*
dtype0
o
!save/RestoreV2_6/shape_and_slicesConst*
valueBB4 0,4*
dtype0*
_output_shapes
:

save/RestoreV2_6	RestoreV2
save/Constsave/RestoreV2_6/tensor_names!save/RestoreV2_6/shape_and_slices*
_output_shapes
:*
dtypes
2
¾
save/Assign_6Assigndnn/logits/biases/part_0save/RestoreV2_6*+
_class!
loc:@dnn/logits/biases/part_0*
_output_shapes
:*
T0*
validate_shape(*
use_locking(
x
save/RestoreV2_7/tensor_namesConst*'
valueBBdnn/logits/weights*
_output_shapes
:*
dtype0
w
!save/RestoreV2_7/shape_and_slicesConst*
_output_shapes
:*
dtype0*"
valueBB10 4 0,10:0,4

save/RestoreV2_7	RestoreV2
save/Constsave/RestoreV2_7/tensor_names!save/RestoreV2_7/shape_and_slices*
_output_shapes
:*
dtypes
2
Ä
save/Assign_7Assigndnn/logits/weights/part_0save/RestoreV2_7*,
_class"
 loc:@dnn/logits/weights/part_0*
_output_shapes

:
*
T0*
validate_shape(*
use_locking(
q
save/RestoreV2_8/tensor_namesConst*
_output_shapes
:*
dtype0* 
valueBBglobal_step
j
!save/RestoreV2_8/shape_and_slicesConst*
valueB
B *
dtype0*
_output_shapes
:

save/RestoreV2_8	RestoreV2
save/Constsave/RestoreV2_8/tensor_names!save/RestoreV2_8/shape_and_slices*
dtypes
2	*
_output_shapes
:
 
save/Assign_8Assignglobal_stepsave/RestoreV2_8*
use_locking(*
T0	*
_class
loc:@global_step*
validate_shape(*
_output_shapes
: 
Ø
save/restore_shardNoOp^save/Assign^save/Assign_1^save/Assign_2^save/Assign_3^save/Assign_4^save/Assign_5^save/Assign_6^save/Assign_7^save/Assign_8
-
save/restore_allNoOp^save/restore_shard

init_2NoOp

init_3NoOp

init_all_tables_1NoOp
8

group_depsNoOp^init_2^init_3^init_all_tables_1
R
save_1/ConstConst*
dtype0*
_output_shapes
: *
valueB Bmodel

save_1/StringJoin/inputs_1Const*<
value3B1 B+_temp_2e9f76c48a7245fba70559c25072ff1a/part*
_output_shapes
: *
dtype0
{
save_1/StringJoin
StringJoinsave_1/Constsave_1/StringJoin/inputs_1*
_output_shapes
: *
	separator *
N
S
save_1/num_shardsConst*
dtype0*
_output_shapes
: *
value	B :
^
save_1/ShardedFilename/shardConst*
_output_shapes
: *
dtype0*
value	B : 

save_1/ShardedFilenameShardedFilenamesave_1/StringJoinsave_1/ShardedFilename/shardsave_1/num_shards*
_output_shapes
: 
·
save_1/SaveV2/tensor_namesConst*
_output_shapes
:	*
dtype0*č
valueŽBŪ	Bdnn/hiddenlayer_0/biasesBdnn/hiddenlayer_0/weightsBdnn/hiddenlayer_1/biasesBdnn/hiddenlayer_1/weightsBdnn/hiddenlayer_2/biasesBdnn/hiddenlayer_2/weightsBdnn/logits/biasesBdnn/logits/weightsBglobal_step
É
save_1/SaveV2/shape_and_slicesConst*w
valuenBl	B10 0,10B4 10 0,4:0,10B20 0,20B10 20 0,10:0,20B10 0,10B20 10 0,20:0,10B4 0,4B10 4 0,10:0,4B *
_output_shapes
:	*
dtype0
·
save_1/SaveV2SaveV2save_1/ShardedFilenamesave_1/SaveV2/tensor_namessave_1/SaveV2/shape_and_slices$dnn/hiddenlayer_0/biases/part_0/read%dnn/hiddenlayer_0/weights/part_0/read$dnn/hiddenlayer_1/biases/part_0/read%dnn/hiddenlayer_1/weights/part_0/read$dnn/hiddenlayer_2/biases/part_0/read%dnn/hiddenlayer_2/weights/part_0/readdnn/logits/biases/part_0/readdnn/logits/weights/part_0/readglobal_step*
dtypes
2		

save_1/control_dependencyIdentitysave_1/ShardedFilename^save_1/SaveV2*
T0*
_output_shapes
: *)
_class
loc:@save_1/ShardedFilename
£
-save_1/MergeV2Checkpoints/checkpoint_prefixesPacksave_1/ShardedFilename^save_1/control_dependency*
N*
T0*
_output_shapes
:*

axis 

save_1/MergeV2CheckpointsMergeV2Checkpoints-save_1/MergeV2Checkpoints/checkpoint_prefixessave_1/Const*
delete_old_dirs(

save_1/IdentityIdentitysave_1/Const^save_1/control_dependency^save_1/MergeV2Checkpoints*
T0*
_output_shapes
: 
~
save_1/RestoreV2/tensor_namesConst*-
value$B"Bdnn/hiddenlayer_0/biases*
dtype0*
_output_shapes
:
q
!save_1/RestoreV2/shape_and_slicesConst*
valueBB10 0,10*
dtype0*
_output_shapes
:

save_1/RestoreV2	RestoreV2save_1/Constsave_1/RestoreV2/tensor_names!save_1/RestoreV2/shape_and_slices*
dtypes
2*
_output_shapes
:
Ģ
save_1/AssignAssigndnn/hiddenlayer_0/biases/part_0save_1/RestoreV2*
_output_shapes
:
*
validate_shape(*2
_class(
&$loc:@dnn/hiddenlayer_0/biases/part_0*
T0*
use_locking(

save_1/RestoreV2_1/tensor_namesConst*.
value%B#Bdnn/hiddenlayer_0/weights*
dtype0*
_output_shapes
:
y
#save_1/RestoreV2_1/shape_and_slicesConst*
_output_shapes
:*
dtype0*"
valueBB4 10 0,4:0,10

save_1/RestoreV2_1	RestoreV2save_1/Constsave_1/RestoreV2_1/tensor_names#save_1/RestoreV2_1/shape_and_slices*
dtypes
2*
_output_shapes
:
Ö
save_1/Assign_1Assign dnn/hiddenlayer_0/weights/part_0save_1/RestoreV2_1*
use_locking(*
T0*3
_class)
'%loc:@dnn/hiddenlayer_0/weights/part_0*
validate_shape(*
_output_shapes

:


save_1/RestoreV2_2/tensor_namesConst*
_output_shapes
:*
dtype0*-
value$B"Bdnn/hiddenlayer_1/biases
s
#save_1/RestoreV2_2/shape_and_slicesConst*
_output_shapes
:*
dtype0*
valueBB20 0,20

save_1/RestoreV2_2	RestoreV2save_1/Constsave_1/RestoreV2_2/tensor_names#save_1/RestoreV2_2/shape_and_slices*
_output_shapes
:*
dtypes
2
Š
save_1/Assign_2Assigndnn/hiddenlayer_1/biases/part_0save_1/RestoreV2_2*
use_locking(*
validate_shape(*
T0*
_output_shapes
:*2
_class(
&$loc:@dnn/hiddenlayer_1/biases/part_0

save_1/RestoreV2_3/tensor_namesConst*.
value%B#Bdnn/hiddenlayer_1/weights*
dtype0*
_output_shapes
:
{
#save_1/RestoreV2_3/shape_and_slicesConst*$
valueBB10 20 0,10:0,20*
_output_shapes
:*
dtype0

save_1/RestoreV2_3	RestoreV2save_1/Constsave_1/RestoreV2_3/tensor_names#save_1/RestoreV2_3/shape_and_slices*
dtypes
2*
_output_shapes
:
Ö
save_1/Assign_3Assign dnn/hiddenlayer_1/weights/part_0save_1/RestoreV2_3*
_output_shapes

:
*
validate_shape(*3
_class)
'%loc:@dnn/hiddenlayer_1/weights/part_0*
T0*
use_locking(

save_1/RestoreV2_4/tensor_namesConst*
_output_shapes
:*
dtype0*-
value$B"Bdnn/hiddenlayer_2/biases
s
#save_1/RestoreV2_4/shape_and_slicesConst*
valueBB10 0,10*
dtype0*
_output_shapes
:

save_1/RestoreV2_4	RestoreV2save_1/Constsave_1/RestoreV2_4/tensor_names#save_1/RestoreV2_4/shape_and_slices*
_output_shapes
:*
dtypes
2
Š
save_1/Assign_4Assigndnn/hiddenlayer_2/biases/part_0save_1/RestoreV2_4*
use_locking(*
validate_shape(*
T0*
_output_shapes
:
*2
_class(
&$loc:@dnn/hiddenlayer_2/biases/part_0

save_1/RestoreV2_5/tensor_namesConst*
_output_shapes
:*
dtype0*.
value%B#Bdnn/hiddenlayer_2/weights
{
#save_1/RestoreV2_5/shape_and_slicesConst*
dtype0*
_output_shapes
:*$
valueBB20 10 0,20:0,10

save_1/RestoreV2_5	RestoreV2save_1/Constsave_1/RestoreV2_5/tensor_names#save_1/RestoreV2_5/shape_and_slices*
dtypes
2*
_output_shapes
:
Ö
save_1/Assign_5Assign dnn/hiddenlayer_2/weights/part_0save_1/RestoreV2_5*
_output_shapes

:
*
validate_shape(*3
_class)
'%loc:@dnn/hiddenlayer_2/weights/part_0*
T0*
use_locking(
y
save_1/RestoreV2_6/tensor_namesConst*
_output_shapes
:*
dtype0*&
valueBBdnn/logits/biases
q
#save_1/RestoreV2_6/shape_and_slicesConst*
dtype0*
_output_shapes
:*
valueBB4 0,4

save_1/RestoreV2_6	RestoreV2save_1/Constsave_1/RestoreV2_6/tensor_names#save_1/RestoreV2_6/shape_and_slices*
dtypes
2*
_output_shapes
:
Ā
save_1/Assign_6Assigndnn/logits/biases/part_0save_1/RestoreV2_6*+
_class!
loc:@dnn/logits/biases/part_0*
_output_shapes
:*
T0*
validate_shape(*
use_locking(
z
save_1/RestoreV2_7/tensor_namesConst*'
valueBBdnn/logits/weights*
_output_shapes
:*
dtype0
y
#save_1/RestoreV2_7/shape_and_slicesConst*"
valueBB10 4 0,10:0,4*
dtype0*
_output_shapes
:

save_1/RestoreV2_7	RestoreV2save_1/Constsave_1/RestoreV2_7/tensor_names#save_1/RestoreV2_7/shape_and_slices*
dtypes
2*
_output_shapes
:
Č
save_1/Assign_7Assigndnn/logits/weights/part_0save_1/RestoreV2_7*
_output_shapes

:
*
validate_shape(*,
_class"
 loc:@dnn/logits/weights/part_0*
T0*
use_locking(
s
save_1/RestoreV2_8/tensor_namesConst*
_output_shapes
:*
dtype0* 
valueBBglobal_step
l
#save_1/RestoreV2_8/shape_and_slicesConst*
dtype0*
_output_shapes
:*
valueB
B 

save_1/RestoreV2_8	RestoreV2save_1/Constsave_1/RestoreV2_8/tensor_names#save_1/RestoreV2_8/shape_and_slices*
dtypes
2	*
_output_shapes
:
¤
save_1/Assign_8Assignglobal_stepsave_1/RestoreV2_8*
_class
loc:@global_step*
_output_shapes
: *
T0	*
validate_shape(*
use_locking(
¼
save_1/restore_shardNoOp^save_1/Assign^save_1/Assign_1^save_1/Assign_2^save_1/Assign_3^save_1/Assign_4^save_1/Assign_5^save_1/Assign_6^save_1/Assign_7^save_1/Assign_8
1
save_1/restore_allNoOp^save_1/restore_shard"B
save_1/Const:0save_1/Identity:0save_1/restore_all (5 @F8"Ö	
trainable_variables¾	»	

"dnn/hiddenlayer_0/weights/part_0:0'dnn/hiddenlayer_0/weights/part_0/Assign'dnn/hiddenlayer_0/weights/part_0/read:0"'
dnn/hiddenlayer_0/weights
  "


!dnn/hiddenlayer_0/biases/part_0:0&dnn/hiddenlayer_0/biases/part_0/Assign&dnn/hiddenlayer_0/biases/part_0/read:0"#
dnn/hiddenlayer_0/biases
 "


"dnn/hiddenlayer_1/weights/part_0:0'dnn/hiddenlayer_1/weights/part_0/Assign'dnn/hiddenlayer_1/weights/part_0/read:0"'
dnn/hiddenlayer_1/weights
  "


!dnn/hiddenlayer_1/biases/part_0:0&dnn/hiddenlayer_1/biases/part_0/Assign&dnn/hiddenlayer_1/biases/part_0/read:0"#
dnn/hiddenlayer_1/biases "

"dnn/hiddenlayer_2/weights/part_0:0'dnn/hiddenlayer_2/weights/part_0/Assign'dnn/hiddenlayer_2/weights/part_0/read:0"'
dnn/hiddenlayer_2/weights
  "


!dnn/hiddenlayer_2/biases/part_0:0&dnn/hiddenlayer_2/biases/part_0/Assign&dnn/hiddenlayer_2/biases/part_0/read:0"#
dnn/hiddenlayer_2/biases
 "


dnn/logits/weights/part_0:0 dnn/logits/weights/part_0/Assign dnn/logits/weights/part_0/read:0" 
dnn/logits/weights
  "

|
dnn/logits/biases/part_0:0dnn/logits/biases/part_0/Assigndnn/logits/biases/part_0/read:0"
dnn/logits/biases ""×
	summariesÉ
Ę
/dnn/dnn/hiddenlayer_0_fraction_of_zero_values:0
"dnn/dnn/hiddenlayer_0_activation:0
/dnn/dnn/hiddenlayer_1_fraction_of_zero_values:0
"dnn/dnn/hiddenlayer_1_activation:0
/dnn/dnn/hiddenlayer_2_fraction_of_zero_values:0
"dnn/dnn/hiddenlayer_2_activation:0
(dnn/dnn/logits_fraction_of_zero_values:0
dnn/dnn/logits_activation:0" 
legacy_init_op


group_deps"
dnn

"dnn/hiddenlayer_0/weights/part_0:0
!dnn/hiddenlayer_0/biases/part_0:0
"dnn/hiddenlayer_1/weights/part_0:0
!dnn/hiddenlayer_1/biases/part_0:0
"dnn/hiddenlayer_2/weights/part_0:0
!dnn/hiddenlayer_2/biases/part_0:0
dnn/logits/weights/part_0:0
dnn/logits/biases/part_0:0"„
model_variables

"dnn/hiddenlayer_0/weights/part_0:0
!dnn/hiddenlayer_0/biases/part_0:0
"dnn/hiddenlayer_1/weights/part_0:0
!dnn/hiddenlayer_1/biases/part_0:0
"dnn/hiddenlayer_2/weights/part_0:0
!dnn/hiddenlayer_2/biases/part_0:0
dnn/logits/weights/part_0:0
dnn/logits/biases/part_0:0" 
global_step

global_step:0"

	variables÷	ō	
7
global_step:0global_step/Assignglobal_step/read:0

"dnn/hiddenlayer_0/weights/part_0:0'dnn/hiddenlayer_0/weights/part_0/Assign'dnn/hiddenlayer_0/weights/part_0/read:0"'
dnn/hiddenlayer_0/weights
  "


!dnn/hiddenlayer_0/biases/part_0:0&dnn/hiddenlayer_0/biases/part_0/Assign&dnn/hiddenlayer_0/biases/part_0/read:0"#
dnn/hiddenlayer_0/biases
 "


"dnn/hiddenlayer_1/weights/part_0:0'dnn/hiddenlayer_1/weights/part_0/Assign'dnn/hiddenlayer_1/weights/part_0/read:0"'
dnn/hiddenlayer_1/weights
  "


!dnn/hiddenlayer_1/biases/part_0:0&dnn/hiddenlayer_1/biases/part_0/Assign&dnn/hiddenlayer_1/biases/part_0/read:0"#
dnn/hiddenlayer_1/biases "

"dnn/hiddenlayer_2/weights/part_0:0'dnn/hiddenlayer_2/weights/part_0/Assign'dnn/hiddenlayer_2/weights/part_0/read:0"'
dnn/hiddenlayer_2/weights
  "


!dnn/hiddenlayer_2/biases/part_0:0&dnn/hiddenlayer_2/biases/part_0/Assign&dnn/hiddenlayer_2/biases/part_0/read:0"#
dnn/hiddenlayer_2/biases
 "


dnn/logits/weights/part_0:0 dnn/logits/weights/part_0/Assign dnn/logits/weights/part_0/read:0" 
dnn/logits/weights
  "

|
dnn/logits/biases/part_0:0dnn/logits/biases/part_0/Assigndnn/logits/biases/part_0/read:0"
dnn/logits/biases "*Č
default_input_alternative:None„
3
inputs)
input_example_tensor:0’’’’’’’’’Q
scoresG
0dnn/multi_class_head/predictions/probabilities:0’’’’’’’’’tensorflow/serving/classify*¹
serving_default„
3
inputs)
input_example_tensor:0’’’’’’’’’Q
scoresG
0dnn/multi_class_head/predictions/probabilities:0’’’’’’’’’tensorflow/serving/classify