PROGRAM _INIT
	step := RSD_INIT;

	(* NodeId for Root/Objects/Server/ServerDiagnostics/SessionsDiagnosticsSummary/SessionDiagnosticsArray is i=3707. *)
	ServerDiagnosticNodeID.NamespaceIndex := 0;
	ServerDiagnosticNodeID.IdentifierType := UAIdentifierType_Numeric;
	ServerDiagnosticNodeID.Identifier := '3707';
	
	ServerDiagnosticVariable := 'SessionDiagnosticsArray';
	SessionDiagnosticsArray;
	tonRepeat.PT := T#5s;

	timeout := T#5s;
END_PROGRAM


PROGRAM _CYCLIC
	CASE step OF
		RSD_INIT:
		ErrorID := 0;
		IF DiagCpuIsSimulated() THEN
			fbUAConnect.ServerEndpointUrl := 'opc.tcp://localhost:4841';
		ELSE
			fbUAConnect.ServerEndpointUrl := 'opc.tcp://localhost:4840';
		END_IF
		fbUAConnect( Execute := FALSE, 
				SessionConnectInfo := SessionConnectInfo, 
				Timeout := timeout,
		); // reset fb
		fbUAConnect( Execute := TRUE );
		step := RSD_W_CONNECT;


		RSD_W_CONNECT:
		IF fbUAConnect.Done THEN (* ok *)
			fbUaNodeGetHandle( Execute := FALSE, 
							ConnectionHdl := fbUAConnect.ConnectionHdl,	
							NodeID := ServerDiagnosticNodeID,
							Timeout := timeout );
			fbUaNodeGetHandle( Execute := TRUE );
			fbUAConnect( Execute := FALSE ); (* reset fb *)
			step := RSD_W_NODE_HANDLE;
		ELSIF fbUAConnect.Error THEN (* error *)
			ErrorID := fbUAConnect.ErrorID;
			fbUAConnect( Execute := FALSE ); (* reset fb *)
			step := RSD_ERROR_CONNECT_TO_SERVER;
		ELSE (* busy *)		
			fbUAConnect();
		END_IF


		RSD_W_NODE_HANDLE:
		IF fbUaNodeGetHandle.Done THEN (* ok *)
			fbUaRead( ConnectionHdl := fbUAConnect.ConnectionHdl,
					  NodeHdl := fbUaNodeGetHandle.NodeHdl,
					  Variable := ServerDiagnosticVariable,
					  Timeout := timeout
					);
			fbUaRead( Variable := ServerDiagnosticVariable, Execute := TRUE );
			fbUaNodeGetHandle( Execute := FALSE ); (* reset fb *)
			step := RSD_W_DIAGNOSTIC_READ;
		ELSIF fbUaNodeGetHandle.Error THEN (* error *)
			ErrorID := fbUaNodeGetHandle.Error;
			fbUaNodeGetHandle( Execute := FALSE ); (* reset fb *)
			step := RSD_ERROR_GET_NODE_HANDLE;
		ELSE (* busy *)
			fbUaNodeGetHandle();
		END_IF


		RSD_W_DIAGNOSTIC_READ:
		IF fbUaRead.Done THEN (* ok *)
			fbUaRead( Variable := ServerDiagnosticVariable, Execute := FALSE );
			tonRepeat( IN := FALSE );

			step := RSD_W_START_READING;
		ELSIF fbUaRead.Error THEN (* error *)
			ErrorID := fbUaRead.ErrorID;
			fbUaRead( Variable := ServerDiagnosticVariable, Execute := FALSE );
			step := RSD_ERROR_READ_DIAGNOSTIC;
		ELSE (* busy *)
			fbUaRead( Variable := ServerDiagnosticVariable );
		END_IF


		RSD_W_START_READING:
		tonRepeat( IN := TRUE );
		IF tonRepeat.Q THEN
			fbUaRead( Variable := ServerDiagnosticVariable, Execute := TRUE );
			step := RSD_W_DIAGNOSTIC_READ;
		END_IF


		RSD_ERROR_CONNECT_TO_SERVER:
		RSD_ERROR_GET_NODE_HANDLE:
		RSD_ERROR_READ_DIAGNOSTIC:


	END_CASE


	
END_PROGRAM





PROGRAM _EXIT
END_PROGRAM