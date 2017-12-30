package org.books.application;

import javax.ejb.Remote;

@Remote
public interface PingService {

	public String ping();
}
