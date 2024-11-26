
TYPE
	RsdaStepType : 
		(
		RSD_INIT,
		RSD_W_CONNECT,
		RSD_W_NODE_HANDLE,
		RSD_W_DIAGNOSTIC_READ,
		RSD_W_START_READING,
		RSD_ERROR_CONNECT_TO_SERVER,
		RSD_ERROR_GET_NODE_HANDLE,
		RSD_ERROR_READ_DIAGNOSTIC
		);
	ApplicationTypeEnum : 
		(
		ApplicationType_Server,
		ApplicationType_Client,
		ApplicationType_ClientAndServer,
		ApplicationType_DiscoveryServer
		);
	ApplicationDescription : 	STRUCT 
		ApplicationUri : STRING[255];
		ProductUri : STRING[255];
		ApplicationName : UALocalizedText;
		ApplicationType : ApplicationTypeEnum;
		GatewayServerUri : STRING[255];
		DiscoveryProfileUri : STRING[255];
		DiscoveryUrlsLength : UANoOfElements;
		DiscoveryUrls : ARRAY[0..9]OF STRING[255];
	END_STRUCT;
	ServiceCounterDataType : 	STRUCT 
		TotalCount : UDINT;
		ErrorCount : UDINT;
	END_STRUCT;
	SessionDiagnosticsDataType : 	STRUCT 
		SessionId : UANodeID;
		SessionName : STRING[255];
		ClientDescription : ApplicationDescription;
		ServerUri : STRING[255];
		EndpointUrl : STRING[255];
		LocaleIdsCount : UANoOfElements;
		LocaleIds : ARRAY[0..4]OF STRING[7];
		ActualSessionTimeout : LREAL;
		MaxResponseMessageSize : UDINT;
		ClientConnectionTime : DATE_AND_TIME;
		ClientLasstContactTime : DATE_AND_TIME;
		CurrentSubscriptionsCount : UDINT;
		CurrentMonitoredItemsCount : UDINT;
		CurrentPublishRequestsInQueue : UDINT;
		TotalRequestCount : ServiceCounterDataType;
		UnauthorizedRequestCount : UDINT;
		ReadCount : ServiceCounterDataType;
		HistoryReadCount : ServiceCounterDataType;
		WriteCount : ServiceCounterDataType;
		HistoryUpdateCount : ServiceCounterDataType;
		CallCount : ServiceCounterDataType;
		CreateMonitoredItemsCount : ServiceCounterDataType;
		ModifyMonitoredItemsCount : ServiceCounterDataType;
		SetMonitoringModeCount : ServiceCounterDataType;
		SetTriggeringCount : ServiceCounterDataType;
		DeleteMonitoredItemsCount : ServiceCounterDataType;
		CreateSubscriptionCount : ServiceCounterDataType;
		ModifySubscriptionCount : ServiceCounterDataType;
		SetPublishingModeCount : ServiceCounterDataType;
		PublishCount : ServiceCounterDataType;
		RepublishCount : ServiceCounterDataType;
		TransferSubscriptionsCount : ServiceCounterDataType;
		DeleteSubscriptionsCount : ServiceCounterDataType;
		AddNodesCount : ServiceCounterDataType;
		AddReferencesCount : ServiceCounterDataType;
		DeleteNodesCount : ServiceCounterDataType;
		DeleteReferencesCount : ServiceCounterDataType;
		BrowseCount : ServiceCounterDataType;
		BrowseNextCount : ServiceCounterDataType;
		TranslateBrowsePathToNodeIdCount : ServiceCounterDataType;
		QueryFirstCount : ServiceCounterDataType;
		QueryNextCount : ServiceCounterDataType;
		RegisterNodesCount : ServiceCounterDataType;
		UnregisterNodesCount : ServiceCounterDataType;
	END_STRUCT;
	SessionDiagnosticsArrayType : 	STRUCT 
		Length : UAArrayLength;
		Data : ARRAY[0..9]OF SessionDiagnosticsDataType;
	END_STRUCT;
END_TYPE
