-- Byte code for access to an expression

class ACCESS_EXPR_B

inherit

	ACCESS_B
		redefine
			analyze, unanalyze, generate,
			print_register, propagate,
			free_register, enlarged, used,
			has_gcable_variable, has_call,
			allocates_memory,
			is_unsafe,
			calls_special_features,
			optimized_byte_node, size,
			pre_inlined_code,
			is_temporary, is_predefined,
			register_name,
			is_hector
		end;

feature -- Visitor

	process (v: BYTE_NODE_VISITOR) is
			-- Process current element.
		do
			v.process_access_expr_b (Current)
		end

feature

	expr: EXPR_B;
			-- The expression

feature -- Status

	is_hector: BOOLEAN is
			-- Is the current expression an hector one ?
			-- Definition: an expression <E> is hector if <E>
			-- is of the form $<A> and <A> is an attribute
			-- or a local variable.
		do
			Result := expr.is_hector
		end

	set_expr (e: EXPR_B) is
			-- Set `expr' to `e'
		do
			expr := e;
		end;

	type: TYPE_I is
			-- Expression type
		do
			Result := expr.type;
		end;

	enlarged: like Current is
			-- Enlarge the expression
		do
			expr := expr.enlarged;
			Result := Current;
		end;

	has_gcable_variable: BOOLEAN is
			-- Is the expression using a GCable variable ?
		do
			Result := expr.has_gcable_variable;
		end;

	has_call: BOOLEAN is
			-- Is the expression using a call ?
		do
			Result := expr.has_call;
		end;

	allocates_memory: BOOLEAN is
		do
			Result := expr.allocates_memory
		end;

	used (r: REGISTRABLE): BOOLEAN is
			-- Is `r' used in the expression ?
		do
			Result := expr.used (r);
		end;

	propagate (r: REGISTRABLE) is
			-- Propagate a register in expression.
		do
			if r = No_register or not used (r) then
				if not context.propagated or r = No_register then
					expr.propagate (r);
				end;
			end;
		end;

	free_register is
			-- Free register used by expression
		do
			expr.free_register;
		end;

	analyze is
			-- Analyze expression
		do
			expr.analyze;
		end;

	unanalyze is
			-- Undo the analysis of the expression
		do
			expr.unanalyze;
		end;

	generate is
			-- Generate expression
		do
			expr.generate;
		end;

	same (other: ACCESS_B): BOOLEAN is
			-- Is other the same access as us ?
		do
			Result := false;
		end;

	print_register is
			-- Print expression value
		do
			if
				(expr.register = Void or expr.register = No_register)
				and then not expr.is_simple_expr
			then
				buffer.put_character ('(');
				expr.print_register;
				buffer.put_character (')');
			else
					-- No need for parenthesis if expression is held in a
					-- register (e.g. a semi-strict boolean op).
				expr.print_register;
			end;
		end;

feature -- Array optimization

	calls_special_features (array_desc: INTEGER): BOOLEAN is
		do
			Result := expr.calls_special_features (array_desc)
		end

	is_unsafe: BOOLEAN is
		do
			Result := expr.is_unsafe
		end

	optimized_byte_node: like Current is
		do
			Result := Current;
			expr := expr.optimized_byte_node
		end

feature -- Inlining

	size: INTEGER is
		do
			Result := 1 + expr.size
		end

	pre_inlined_code: like Current is
		do
			Result := Current;
			expr := expr.pre_inlined_code
		end

	is_temporary: BOOLEAN is
			-- Is register a temporary one ?
		do
			Result := expr.is_temporary
		end;

	is_predefined: BOOLEAN is
			-- Is register a predefined one ?
		do
			Result := expr.is_predefined
		end;

	register_name: STRING is
			-- The ASCII representation of the register
		do
			Result := expr.register_name
		end
end
