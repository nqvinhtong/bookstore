package org.books.application;

import javax.naming.Context;
import javax.naming.InitialContext;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import static org.testng.Assert.assertNotNull;

public class PingServiceIT {

	private static final String SERVICE_NAME = "java:global/bookstore-app/bookstore-ejb/PingService";
	private static PingService pingService;

	@BeforeClass
	public void lookupService() throws Exception {
		Context jndiContext = new InitialContext();
		pingService = (PingService) jndiContext.lookup(SERVICE_NAME);
	}

	@Test
	public void ping() {
		String message = pingService.ping();
		assertNotNull(message);
	}
}
